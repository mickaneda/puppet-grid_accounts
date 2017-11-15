define grid_accounts::delete_groups($groups = {}){
  
####### Delete groups
  $group_yaml = inline_template('
---
<% @groups.each_pair do |fqan, data|
  next if data["ensure"] != "absent" %>
  <%= data["group"] %>:
   name: <%= data["group"] %>
   ensure: <%= data["ensure"] %>
<% end -%>
    ')

#notify { "Converted: $group_yaml": }
  $groupdata = parseyaml($group_yaml)
  if $groupdata {
    create_resources('group',$groupdata)
  }
}
      
