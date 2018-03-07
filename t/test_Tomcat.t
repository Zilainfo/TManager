use strict;
use warnings;
use Test::More qw(no_plan);

use Net::Tomcat;

subtest 'create new object' => sub {
  my %ATTR = (
    username  => 'myusername',
    password  => 'mypass',
    hostname  => 'myhostname.com',
    path      => '/mypath',
    war       => '/path/my.war',
    error_log => 1,
    debug     => 1,
    proto     => 'http',
    port      => 8080,
  );

  my $tc = Net::Tomcat->new(%ATTR);

   ok($tc);
};

subtest 'correcly initialize object' => sub {
  my %ATTR = (
    username  => 'myusername',
    password  => 'mypass',
    hostname  => 'myhostname.com',
    path      => '/mypath',
    war       => '/path/my.war',
    error_log => 1,
    debug     => 1,
    proto     => 'http',
    port      => 8080,
  );
  my $tc = Net::Tomcat->new(%ATTR);
  
  is($tc->{username}, 'myusername');
  is($tc->{password}, 'mypass');
  is($tc->{hostname}, 'myhostname.com');
  is($tc->{path}, '/mypath');
  is($tc->{war}, '/path/my.war');
  is($tc->{error_log}, 1);
  is($tc->{debug}, 1);
  is($tc->{proto}, 'http');
  is($tc->{port}, 8080);
};



done_testing;