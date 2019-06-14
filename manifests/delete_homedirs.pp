define grid_accounts::delete_homedirs($home_path = "/home", $dirs = {}){

####### Delete home dirs
  $dirs_yaml = inline_template('
---
<% @dirs.each_pair do |fqan, data |
  next if data["ensure"] != "absent" %>
  <% (1..data["users_num"]).each do |i| %>
    <% ndigit = data["ndigit"] ? data["ndigit"] : 3 %>
    <% user = data["user_prefix"] ? data["user_prefix"] :  sprintf("%s%#0#{ndigit}i",data["group"],i) %>
    <% if data["users_num"] > 1 && ndigit > 0 %>
      <% user = sprintf("%s%#0#{ndigit}i",user,i) %>
    <% end %>
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
      
