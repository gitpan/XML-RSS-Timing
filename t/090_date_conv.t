
require 5;
use strict;
use Test;
BEGIN { plan tests => 70 }

print "# Starting ", __FILE__ , " ...\n";
ok 1;
#sub XML::RSS::Timing::DEBUG () {5}
use XML::RSS::Timing;

use Time::Local;
my $E1970 = timegm(0,0,0,1,0,70);
ok 1;
print "# E1970 = $E1970 s  (", scalar(gmtime($E1970)), ")\n";

sub r {
  my $x;
  eval { $x = XML::RSS::Timing->_iso_date_to_epoch($_[0]) };
  $x -= $E1970 if defined $x;
  return $x;
}

ok r('1997');
ok r('1997-07');
ok r('1997-07-16');
ok r('1994-11-05T13:15');
ok r('1994-11-05T13:15:30');
ok r('1994-11-05T13:15:30Z');
ok r('1997-07-16T19:20+01:00');
ok r('1994-11-05T08:15:30-05:00');
ok r('1997-07-16T19:20:30+01:00');
ok r('1997-07-16T19:20:30.45+01:00');

ok !r('sprok');
ok !r('1');
ok !r('12');
ok !r('123');
ok !r('12345');
ok  r('2000');
ok !r('2000-13');
ok !r('2000-13-29');
ok !r('2000-12-33');

print "# OK, now testing accuracy...\n";

ok r('1970'), 0;
ok r('1970-01'), 0;
ok r('1970-01-01'), 0;
ok!r('1970-01-01T00'); # just-hours is invalid

ok r('1970-01-01T00:00'), 0;
ok r('1970-01-01T00:00:00'), 0;
ok r('1970-01-01T00:00:00.0'), 0;
ok r('1970-01-01T00:00:00.1'), 0;
ok r('1970-01-01T00:00:00.12345'), 0;

ok r('1970-01-01T00:00:00.0Z'), 0;
ok r('1970-01-01T00:00:00.1Z'), 0;
ok r('1970-01-01T00:00:00.12345Z'), 0;

ok!r('1970-01-01T00:00:00.0+00');  # just-hours in the TZ is invalid
ok r('1970-01-01T00:00:00.1+00:00'), 0;
ok r('1970-01-01T00:00:00.12345+00:00'), 0;

ok!r('1970-01-01T01:00:00.0+01'); # just-hours in the TZ is invalid
ok r('1970-01-01T01:00:00.1+01:00'), 0;
ok r('1970-01-01T01:00:00.12345+01:00'), 0;


ok r('1970-01-01T00:04:00.0Z'),		 240;
ok r('1970-01-01T00:04:00.1Z'),		 240;
ok r('1970-01-01T00:04:00.12345Z'),	 240;

ok!r('1970-01-01T00:04:00.0+00'); # just-hours in the TZ is invalid
ok r('1970-01-01T00:04:00.1+00:00'),	 240;
ok r('1970-01-01T00:04:00.12345+00:00'), 240;
ok!r('1970-01-01T00:04:00.0-00'); # just-hours in the TZ is invalid
ok r('1970-01-01T00:04:00.1-00:00'),	 240;
ok r('1970-01-01T00:04:00.12345-00:00'), 240;

ok!r('1970-01-01T01:04:00.0+01'); # just-hours in the TZ is invalid
ok r('1970-01-01T01:04:00.1+01:00'),	 240;
ok r('1970-01-01T01:04:00.12345+01:00'), 240;

ok r('1970-01-01T02:04:00.1+02:00'),	 240;
ok r('1970-01-01T02:04:00.12345+02:00'), 240;

ok r('1970-01-01T20:04:00.1+20:00'),	 240;
ok r('1970-01-01T20:04:00.12345+20:00'), 240;

ok r('1970-01-01T20:24:00.1+20:20'),	 240;
ok r('1970-01-01T20:24:00.12345+20:20'), 240;

ok r('1994-11-05T08:15:30-05:00');
ok r('1994-11-05T13:15:30Z');
ok r('1994-11-05T08:15:30-05:00'), r('1994-11-05T13:15:30Z');

ok r('1969-12-31T23:04:00.1-01:00'),	 240;
ok r('1969-12-31T23:04:00.12345-01:00'), 240;
ok r('1969-12-31T22:34:00.1-01:30'),	 240;
ok r('1969-12-31T22:34:00.12345-01:30'), 240;

ok r('1969-12-31T22:34:00.12345-01:30'), 240;

my $x = 1_075_012_060;
ok r('2004-01-25T06:27:40-00:00'), $x;
ok r('2004-01-25T06:27:40Z'), $x;
ok r('2004-01-25T06:27:40'), $x;
ok r('2004-01-24T21:27:40-09:00'), $x;


print "# bye\n";
ok 1;

__END__
