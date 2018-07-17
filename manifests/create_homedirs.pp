# Create home directories
define grid_accounts::create_homedirs($home_path = "", $dirs = {}){

  $yaml = inline_template('
---
<% @dirs.each_pair do |fqan, data |
   next if data["ensure"] == "absent" %>
  <% (1..data["users_num"].to_i).each do |i| %>
    <% ndigit = data["ndigit"] ? data["ndigit"] : 3 %>
    <% user = data["user_prefix"] ? sprintf("%s%#0#{ndigit}i",data["user_prefix"],i) :  sprintf("%s%#0#{ndigit}i",data["group"],i) %>
    <%= user %>:
      ensure: "directory"
      path: <%= sprintf("%s/%s", @home_path, user) %>
      owner: <%= user %>
      group: <%= data["group"] %>
      mode: "0700"
    <% end %>
<% end -%>
  ')

  $dirdata = parseyaml($yaml)
#  notify { "$dirdata": } 
  if $dirdata {
    create_resources('file',$dirdata)
  }
}
