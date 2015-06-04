#
# Class to execute "barbican-manage db_sync
#
class barbican::db::sync {
  exec { 'barbican-manage db_sync':
    path        => '/usr/bin',
    user        => 'barbican',
    refreshonly => true,
    subscribe   => [Package['barbican'], Barbican_config['database/connection']],
    require     => User['barbican'],
  }

  Exec['barbican-manage db_sync'] ~> Service<| title == 'barbican' |>
}
