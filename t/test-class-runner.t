#!/usr/bin/env perl
use warnings;
use strict;
use FindBin;
use lib "$FindBin::Bin/lib";
use Test::Yesh::Controller::Setup;

Test::Yesh::Controller::Setup->runtests;
