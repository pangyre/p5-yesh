#!/usr/bin/env perl
use inc::Module::Install;

name "Yesh";
all_from "lib/Yesh.pm";

requires "Catalyst::Runtime" => "5.80007";
requires "Catalyst::Plugin::ConfigLoader";

build_requires "Pod::Spell";
build_requires "Test::Spelling";
requires "Catalyst::Plugin::ConfigLoader::Multi";

requires "Catalyst::Plugin::Static::Simple";
requires "Catalyst::Action::RenderView";
requires "Catalyst::Controller::REST";
requires "Catalyst::Plugin::Authorization::Roles";

requires "Catalyst::Plugin::Authentication";
requires "Catalyst::Plugin::Session::State::Cookie";
requires "Catalyst::Plugin::Session";
requires "Catalyst::Authentication::Realm::SimpleDB"; # I think this is a BUG!
requires "Catalyst::View::TT::Alloy";
requires "HTML::FormFu::Model::DBIC";
requires "FCGI::ProcManager";
requires "DBIx::Class::ResultSet::HashRef";

requires "Number::Format";
requires "HTML::FormFu";
requires "Catalyst::Controller::HTML::FormFu";

requires "Data::UUID";
requires "DBIx::Class::EncodedColumn";

requires "Class::MOP" => 0.92;
requires "Moose" => 0.89;
requires "parent";
requires "YAML";
requires "DBIx::Class" => 0.081;
requires "DBIx::Class::EncodedColumn";
requires "Crypt::Eksblowfish::Bcrypt";
requires "JSON::XS";
requires "XML::LibXML";
requires "URI";
requires "CatalystX::Plugin::Blurb";
requires "DateTime::Format::SQLite";

requires "Catalyst::Plugin::RequireSSL";

recommends "Catalyst::Manual";
recommends "IPC::Run";
recommends "File::Find::Rule";
recommends "File::Which"; # Right now it's a fatal without.
recommends "Pod::POM";
recommends "Proc::ProcessTable";
recommends "IPC::Run";
recommends "Schedule::At";
#recommends "LWPx::ParanoidAgent";
#recommends "Catalyst::Plugin::Authentication::Credential::OpenID";


# requires "URI::QueryParam";

test_requires "HTTP::Request::Common";

catalyst;

if ( $Module::Install::AUTHOR )
{
    system("pod2text lib/Yesh.pm > README") == 0
        or die "Couldn't update the README file";
    system("pod2text lib/Yesh/Manual/ReleaseNotes.pod > Changes") == 0
        or die "Couldn't update the Changes file";
}

install_script glob("script/*.pl");
auto_install;
WriteAll;

__END__

# requires "Catalyst::Authentication::Realm::SimpleDB";
