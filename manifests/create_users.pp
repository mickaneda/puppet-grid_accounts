# Create pool users
define grid_accounts::create_users( $home_path = "/home", $users = {}){

  $yaml = inline_template('
---
<% @users.each_pair do |fqan, data |
   next if data["ensure"] == "absent" %>
  <% uid_fl = data["uid_range"].split("-");
     uids = (uid_fl[0]..uid_fl[1]).to_a;
     (1..data["users_num"].to_i).each do |i| %>
  <% user = sprintf("%s%#03i",data["group"],i) %>
    <%= user %>:
       ensure: <%= data["ensure"] %>
       name: <%= user %>
       uid: <%= uids[i-1] %>
       gid: <%= data["gid"] %>
       groups: <%= data["vo_group"] %>
       password: \'*NP*\'
       home: <%= sprintf("%s/%s",@home_path,user) %>
       comment: <%= data["comment"] %>
  <% end %>
<% end -%>
  ')

  $userdata = parseyaml($yaml)
#  notify {"Blah Blah $userdata": } 
  if $userdata {
    create_resources('user',$userdata)
  }

}
