# limit_bandwidth

Uses tc to limit incoming and outcoming bandwidth.

We limit incoming bandwidth depending on remote host ip and remote port.
We limit outcoming bandwidth depending on remote host ip and local port.

Because we only set one rule and there are no other class to borrow bandwidth from, we use the same value for rate and ceil.

The scripts are used to setup rules for clear environment. There are no code about clear or change existent configures.
