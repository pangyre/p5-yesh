#!/usr/bin/env perl
use inc::Module::Install;

name "Yesh";
all_from "lib/Yesh.pm";

requires "Catalyst::Runtime" => "5.80007";
requires "Catalyst::Plugin::ConfigLoader";
requires "Catalyst::Plugin::Static::Simple";
requires "Catalyst::Action::RenderView";
requires "parent";
requires "YAML";
requires "Catalyst::Controller::REST";
requires "DBIx::Class";
requires "DBIx::Class::EncodedColumn";
# requires "Catalyst::Authentication::Realm::SimpleDB";

test_requires "HTTP::Request::Common";

catalyst;

if ( $Module::Install::AUTHOR )
{
    system("pod2text lib/Yesh.pm > README") == 0
        or die "Couldn't update the README";
}

install_script glob("script/*.pl");
auto_install;
WriteAll;
