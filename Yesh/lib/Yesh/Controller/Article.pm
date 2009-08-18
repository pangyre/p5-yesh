package Yesh::Controller::Article;
use strict;
use warnings;
use parent 'Catalyst::Controller::HTML::FormFu';

sub index :Path Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( articles => $c->model("DBIC::Article")->live_rs({},
                                                               { prefetch => [qw( license )],
                                                                 order_by => "golive DESC" }) );
#    die $c->stash->{articles}->count;
#use YAML;    die Dump $c->model("DBIC");;
}

sub load :Chained("/") PathPart("a") CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $id ||= $c->request->arguments->[0]; # for forwards
    $c->stash->{article} = $c->model("DBIC::Article")->find($id)
        or die "RC_404: No such article";
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

sub create :Local {
    my ( $self, $c ) = @_;

    unless ( $c->check_user_roles("author") )
    {
        $c->forward("Login","index"); # response->redirect($c->action_uri("Login","index"));
        $c->blurb("article/created");
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
            $c->response->redirect( $c->action_uri("Article","edit",[$article->id]) );
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

sub edit :Chained("load") Args(0) FormConfig {
    my ( $self, $c ) = @_;
    my $article = $c->stash->{article};

    my $form = $c->stash->{form};
    $form->model->default_values( $article );

    if ( $form->submitted_and_valid ) {
        $form->save_to_model($article);
#        $article->update();
        #        $c->flash->{status_msg} = 'Article created';
        $c->response->redirect($c->request->uri);
        $c->detach;
    }
    $self->_load_related_form_data($c);
}

sub xedit :Chained("load") Args(0) {
    my ( $self, $c ) = @_;
    my $article = $c->stash->{article};

#    $c->stash( article => { $article->get_columns } );
    if ( $c->request->method eq "POST" )
    {
        if ( $article->token ne $c->request->param("token") )
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
