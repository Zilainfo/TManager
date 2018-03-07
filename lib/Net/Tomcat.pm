package Net::Tomcat;

use strict;
use warnings;
use LWP;

our $VERSION = '0.01';

our $ATTR = {
	username	=>	{ required => 1					           },
	password	=>	{ required => 1					           },
	hostname	=>	{ required => 1					           },
	path      =>	{ required => 1					           },
	war       =>	{ required => 0					           },
  error_log =>  { required => 0,                   },
  debug     =>  { required => 0,                   },
  proto     =>  { required => 0, default => 'http' },
  port      =>  { required => 0, default => 8080   },
};

#**********************************************************
# Init
#**********************************************************
sub new {
  my ($class, %args) = @_;
  my $self = {};

  bless($self, $class);

  $self->{__ua}	= LWP::UserAgent->new();

  for ( keys %{ $ATTR } ) {
	  $ATTR->{$_}->{required} && ( defined $args{$_} || die "Configuration parameter  $_  is not supported or wrong\n" );
	  $self->{$_} = ( $args{$_} || $ATTR->{$_}->{default} );
  }

	return $self
}

#**********************************************************
=head2 __request($url) - send request

  Arguments:
    $url - URL 

  Results:
    $res->content - Request–response
 
=cut
#**********************************************************
sub __request {
  my $self = shift;
  my ($url) = @_;
  
	my $res = $self->{__ua}->get(
	  "$self->{proto}://$self->{username}:$self->{password}"
		. "\@$self->{hostname}:$self->{port}$url" 
	);

	if( $res->content =~ /FAIL/ ){
    $self->__log($res->content);
  }
  elsif($res->is_success){
  	return $res->content;
  }
  else{
  	$self->__log( "Unable to retrieve content\n");
  }

    return 0;
}

#**********************************************************
=head2 __log($str) - Write log file

  Arguments:
    $str - Info

=cut
#**********************************************************
sub __log {
  my $self = shift;
  my ($str) = @_;

	if( $self->{error_log} ) { 
		my $seq = '../logs/error_log.txt';
    open(my $fh, '>>', $seq) or die "Could not open file $seq: $!";
    print $fh $str;
    close $fh;
  }
  
  if( $self->{debug} ){
  	print $str;
  }
 
  return 1
}

#**********************************************************
=head2 deploy($self->{path}, $war) - Deploy application in context path from .WAR file

  Returns:
    $res - Result 

=cut
#**********************************************************
sub deploy {
  my $self = shift;

  my $res = $self->__request("/manager/text/deploy?path=$self->{path}&war=file:$self->{war}");
  $self->__log($res);

  return $res;
}

#**********************************************************
=head2 undeploy() - Undeploy application at context path 

  Returns:
    $res - Result 

=cut
#**********************************************************
sub undeploy {
  my $self = shift;

  my $res = $self->__request("/manager/text/undeploy?path=$self->{path}");
  $self->__log($res) if $res;

  return $res;
}

#**********************************************************
=head2 start() - Started application at context path

  Returns:
    $res - Result 

=cut
#**********************************************************
sub start {
  my $self = shift;

  my $res = $self->__request("/manager/text/start?path=$self->{path}");
  $self->__log($res) if $res;

  return $res;
}

#**********************************************************
=head2 stop() - Stopped application at context path

  Returns:
    $res - Result 

=cut
#**********************************************************
sub stop {
  my $self = shift;

  my $res = $self->__request("/manager/text/stop?path=$self->{path}");
  $self->__log($res) if $res;

  return $res;
}

#**********************************************************
=head2 info() - Session information for application at context path

  Returns:
    $res - Result 

=cut
#**********************************************************
sub info {
  my $self = shift;
    
  my $res = $self->__request("/manager/text/expire?path=$self->{path}&idle=0");
  $self->__log($res) if $res;

  return $res;
}

#**********************************************************
=head2 check() - Session information for application at context path

  Returns:
    $res - Result 

=cut
#**********************************************************
sub check { 
  my $self = shift;
    
  my $res = $self->__request("$self->{path}");
  
  if($res){
    $self->__log( "OK - Webapp $self->{path} Available \n");
  }
  else{
    $self->__log( "OK - $self->{path} Not available \n");
  }

  return $res;
}
