# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   mhn_dionaea { 'namevar': }
define mhn_dionaea (
  String $user,
  Stdlib::Host $hpf_server,
  String $hpf_id,
  String $hpf_secret,
  Stdlib::Port $hpf_port = 10000,
) {
  include mhn_dionaea::packages
}
