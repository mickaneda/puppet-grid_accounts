# Create groups for pool users
define grid_accounts::create_groups($groups = {}){

  $yaml = inline_template('
---
<% @groups.each_pair do |fqan, data|
  next if data["ensure"] == "absent" %>
  <%= data["group"] %>:
   name: <%= data["group"] %>
   gid: <%= data["gid"] %>
   ensure: <%= data["ensure"] %>
<% end -%>
')

  #notify { "Converted: $yaml": }
  $groupdata = parseyaml($yaml)
#  notify { "Converted: $groupdata": }
  if $groupdata {
    create_resources('group',$groupdata)
  }
}

