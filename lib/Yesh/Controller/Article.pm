package Yesh::Controller::Article;
use strict;
use warnings;
use parent 'Catalyst::Controller::HTML::FormFu';

__PACKAGE__->config( articles_per_page => 10 );

sub index :Path Args(0) {
    my ( $self, $c ) = @_;
    my $page = $c->req->param("page") || 1;
    $page =~ s/\D+//g;
    $page = 1 unless $page > 1;
    $c->stash->{articles} =
        $c->model("DBIC::Article")
            ->live_rs({},
                      {
                       prefetch => [qw( license user )],
                       join => [qw( license user )],
                       order_by => "golive DESC",
                       page => $page,
                       rows => $self->{articles_per_page}
                      });
}

sub load :Chained("/") PathPart("a/id") CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $id ||= $c->request->arguments->[0]; # for forwards
    $c->stash->{article} = $c->model("DBIC::Article")->find($id)
        or die "RC_404: No such article";
# forward to search with it?
}

sub view :PathPart("") Chained("load") Args(0) {
    my ( $self, $c ) = @_;
    die "RC_410" unless $c->stash->{article}->is_live;
}

sub preview :Chained("load") Args(0) {
    my ( $self, $c ) = @_;
    my $article = $c->stash->{article};
    die "RC_404" unless $c->user_exists;
    unless ( $c->user->can_preview_article($article) )
    {
        die "RC_403";
    }
}

sub create :Local Args(0) FormConfig {
    my ( $self, $c ) = @_;
    unless ( $c->user_exists )
    {
        $c->response->redirect($c->uri_for("/login"));
        $c->flash( return_to => $c->request->uri->as_string );
        # set the blurb
        $c->detach();
    }
    unless ( $c->check_user_roles("author") )
    {
        $c->blurb("article/author_to_create");
        die "RC_403";
    }

    my $form = $c->stash->{form};
    $form->constraints_from_dbic($c->model("DBIC::Article"));
    $form->render;

    if ( $form->submitted_and_valid ) {
        $form->add_valid(user => $c->user->id);
        my $article = $form->model->create({resultset => 'Article'});
        $c->flash_blurb(1);
        $c->blurb("article/created");
        $c->response->redirect( $c->uri_for_action("/article/edit",[$article->id]) );
        $c->detach;
    }

    $self->_load_related_form_data($c);
}

sub edit :Chained("load") Args(0) FormConfig {
    my ( $self, $c ) = @_;
    my $article = $c->stash->{article};

    my $form = $c->stash->{form};
    $form->constraints_from_dbic($c->model("DBIC::Article"));
    $form->render;

    if ( $form->submitted_and_valid )
    {
        if ( $article->digest ne $c->request->param("digest") )
        {
            $c->blurb({ id => "error",
                        content => "Nope! This article was updated elsewhere since you loaded this page!" });
            $c->detach;
        }
        $form->save_to_model($article);
        # flash blurb here
        $c->response->redirect($c->request->uri);
        $c->detach;
    }
    elsif ( not $form->submitted )
    {
        $form->default_values({ digest => $article->digest });
        $form->model->default_values( $article );
    }
    $self->_load_related_form_data($c);
}

sub xedit :Chained("load") Args(0) {
    my ( $self, $c ) = @_;
    my $article = $c->stash->{article};

#    $c->stash( article => { $article->get_columns } );
    if ( $c->request->method eq "POST" )
    {
        if ( $article->digest ne $c->request->param("digest") )
        {
            $c->blurb({ id => "error",
                        content => "Nope! This article was updated elsewhere since you loaded this page!" });
            $c->detach;
        }
        eval {
            for my $col ( qw( parent title template license body note
                              status comment_flag golive
                              takedown ) )
            {
                $article->$col( $c->request->param($col) ) if defined $c->request->param($col);
            }
        };

        if ( $article->is_changed
             and
             $c->request->param("token") ne $article->token )
        {
            $c->log->debug("Changed: " . join("+", $article->is_changed));
            $article->update;
            $c->flash_blurb(1);
            $c->blurb("article/updated");
        }
        $c->response->redirect( $c->action_uri("Article","edit",[$article->id]) );
        $c->detach();

    }
    $self->_load_related_form_data($c);
}

sub _load_related_form_data {
    my ( $self, $c ) = @_;
#    my $stati = $c->model("DBIC::Article")->result_source->column_info("status");
#    my $comment_flags = $c->model("DBIC::Article")->result_source->column_info("comment_flag");
    $c->stash( license => $c->model("DBIC::License")->search_rs(),
#               comment_flags => $comment_flags->{extra}->{list},
#               default_comment_flag => $comment_flags->{default_value},
#               stati => $stati->{extra}->{list},
#               status_default => $stati->{default_value},
               );
}


1;

__END__

sub create :Local {
    my ( $self, $c ) = @_;

    unless ( $c->check_user_roles("author") )
    {
        $c->response->redirect($c->uri_for("/login"));
        # set the blurb
        $c->detach();
    }

    if ( $c->request->method eq 'POST' )
    {
        my %data = ( user => $c->user->id );
        for my $col ( qw( parent title template license body note status comment_flag ) )
        {
            $data{$col} = $c->request->param($col)
                if $c->request->param($col);
        }

        my $article = eval { $c->model("DBIC")->schema
                                 ->txn_do(sub{
                                     $c->model("DBIC::Article")->create(\%data)
                                     })
                             };

        if ( $article and $article->in_storage )
        {
            $article->update;
            $c->flash_blurb(1);
            $c->blurb("article/created");
            $c->response->redirect( $c->uri_for_action("/article/edit",[$article->id]) );
            $c->detach();
        }
        else
        {
            die $@;
        }
        $c->stash( article => $article || \%data );
    }
    $self->_load_related_form_data($c);
}
