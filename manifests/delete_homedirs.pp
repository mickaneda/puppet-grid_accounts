define grid_accounts::delete_homedirs($home_path = "/home", $dirs = {}){

####### Delete home dirs
  $dirs_yaml = inline_template('
---
<% @dirs.each_pair do |fqan, data |
  next if data["ensure"] != "absent" %>
  <% (1..data["users_num"]).each do |i| %>
    <% user = data["user_prefix"] ? sprintf("%s%#03i",data["user_prefix"],i) :  sprintf("%s%#03i",data["group"],i) %>
    <%= user %>:
      ensure: <%= data["ensure"] %>
      path: <%= sprintf("%s/%s", @home_path, user) %>
      recurse: true
      purge: true
      force: true
      <% end %>
<% end -%>
  ')
   $dirdata = parseyaml($dirs_yaml)
   if $dirdata {
#   notify { "$dirdata": }
   create_resources('file',$dirdata)
  }    
}
      
