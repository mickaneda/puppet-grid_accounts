# Create home directories
define grid_accounts::create_homedirs($home_path = "", $dirs = {}){

  $yaml = inline_template('
---
<% @dirs.each_pair do |fqan, data |
   next if data["ensure"] == "absent" %>
  <% (1..data["users_num"].to_i).each do |i| %>
    <% user = sprintf("%s%#03i",data["group"],i) %>
    <%= user %>:
      ensure: "directory"
      path: <%= sprintf("%s/%s", @home_path, user) %>
      owner: <%= sprintf("%s%#03i",data["group"],i) %>
      group: <%= data["group"] %>
      mode: "0700"
      require: File[<%= @home_path %>] 
    <% end %>
<% end -%>
  ')

  $dirdata = parseyaml($yaml)
#  notify { "$dirdata": } 
  create_resources('file',$dirdata)
}
