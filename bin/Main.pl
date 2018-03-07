#!/usr/bin/perl

use lib '../lib';
use Net::Tomcat;
use Getopt::Long;

our %ATTR = ( action => 'test' );

GetOptions ( 
  'username=s' => \$ATTR{username},
  'password=s' => \$ATTR{password}, 
  'hostname=s' => \$ATTR{hostname},
  'war=s'      => \$ATTR{war},
  'path=s'     => \$ATTR{path},
  'proto=s'	   =>	\$ATTR{proto},
  'port=s'	   =>	\$ATTR{port},
  'action=s'   => \$ATTR{action},
  'error_log'  => \$ATTR{error_log},
  'debug'      => \$ATTR{debug},
  'config'     => \$ATTR{config},
  'help'       => \&help_info,
) 
or die("Error in command line arguments\n");

get_conf($ATTR{config});

our $tc = Net::Tomcat->new(%ATTR);

my %actions = ( test    => \&test,
                deploy   => sub { $tc->deploy()   or die  print "$tc->{error_msgs} Script execution aborted \n" },
                undeploy => sub { $tc->undeploy() or die  print "$tc->{error_msgs} Script execution aborted \n" },
                info     => sub { $tc->info()     or die  print "$tc->{error_msgs} Script execution aborted \n" },
                start    => sub { $tc->start()    or die  print "$tc->{error_msgs} Script execution aborted \n" },
                stop     => sub { $tc->stop()     or die  print "$tc->{error_msgs} Script execution aborted \n" },
                check    => sub { $tc->check()},
);

if($actions{$ATTR{action}}){
  $actions{$ATTR{action}}->()
}
else{
	print "Action is not supported or wrong\n";
}


#**********************************************************
=head2 test() - test all actions

=cut
#**********************************************************
sub test{
	my $test_score = 0;

  $tc->deploy()   and $test_score++;
  $tc->start()    and $test_score++;
  $tc->check()    and $test_score++;
  $tc->info()     and $test_score++;
  $tc->stop()     and $test_score++;
  $tc->undeploy() and $test_score++;
  $tc->check()    or  $test_score++;

  print "Test $test_score/7 complete \n";

  return 1;
}

#**********************************************************
=head2 __get_conf($url) - send request

  Arguments:
    $url - URL 

  Results:
    $res->content - Request–response
 
=cut
#**********************************************************
sub get_conf {
  my ($dir) = @_;
  my $new_conf;

  $dir = $dir ? $dir : '../config/conf.cfg';
  open(my $fh, '<', $dir) or die "Could not open config $dir $!";

  while (my $row = <$fh>) {
    chomp $row;
    if($row =~ /^\w+/){
      $row =~  s/\s//g;

      my ($conf_name, $conf_value) = split(/=/, $row);
      $ATTR{$conf_name} = $ATTR{$conf_name} ? $ATTR{$conf_name} : $conf_value;
      $new_conf .= "$conf_name = $ATTR{$conf_name}\n";
    }
    else{
    	$new_conf .= $row;
    }
  }

  close $fh;

  if($ATTR{save_conf}){
    open(my $fh, '>', '../config/conf.cfg') or die "Could not open config '../config/conf.cfg' $!";
    print $fh $new_conf;
    close $fh;
  }

  return 1
}

1