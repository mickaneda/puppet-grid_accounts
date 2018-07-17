# Create pool_users and mapfiles
class grid_accounts(
  $pool_users    = {},
  $home_path = "",
  $resources = { accounts => true, gridmapfile => true, groupmapfile => false, gridmapdir => false }
) {
  # $pool_users = { FQAN => { group => 'atlas', gid => '1001', user_prefix => 'atlas', ndigit => '3', vo_group => 'atlas', uid_range => '9000-9049', users_num => 20 }

  if $resources['accounts'] {
#    notify { "accounts......": }
    # If ensure "present" create groups, users, homedirs
    Grid_accounts::Create_groups["pool_groups"] -> Grid_accounts::Create_users["pool_users"] -> Grid_accounts::Create_homedirs["pool_homedirs"]
    grid_accounts::create_groups{ "pool_groups": groups => $pool_users }
    grid_accounts::create_users{ "pool_users": home_path => $home_path, users => $pool_users }
    grid_accounts::create_homedirs{ "pool_homedirs": home_path => $home_path, dirs => $pool_users }

    # If ensure "absent" delete groups, users, homedirs
    Grid_accounts::Delete_users["pool_users"] -> Grid_accounts::Delete_groups["pool_groups"] -> Grid_accounts::Delete_homedirs["pool_homedirs"]
    grid_accounts::delete_users{ "pool_users": users => $pool_users }
    grid_accounts::delete_groups{ "pool_groups": groups => $pool_users }
    grid_accounts::delete_homedirs{ "pool_homedirs": home_path => $home_path, dirs => $pool_users }

  }

  if $resources['gridmapfile'] {

    #   notify { "grid-mapfile......": }
    grid_accounts::gmap{"grid-mapfile": type => "grid", role_maps => $pool_users }
  }
  if $resources['gridmapdir'] {

    #   notify { "gridmapdir......": }
    grid_accounts::gmap{"gridmapdir": type => "dir", role_maps => $pool_users }
  }

  if $resources['groupmapfile'] {

    #   notify { "groupmapfile......": }
    grid_accounts::gmap{"groupmapfile": type => "group", role_maps => $pool_users }
  }
}
