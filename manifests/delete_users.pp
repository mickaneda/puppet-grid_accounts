define grid_accounts::delete_users($users = {}){

####### Delete pool users
  $user_yaml = inline_template('
---
<% @users.each_pair do |fqan, data |
   next if data["ensure"] != "absent" %>
  <% (1..data["users_num"]).each do |i|
     user = sprintf("%s%#03i",data["group"],i) %>
    <%= user %>:
      ensure: <%= data["ensure"] %>
      name: <%= user %>
    <% end %>
<% end -%>
  ')

  $userdata = parseyaml($user_yaml)
  if $userdata {
#    notify {"Blah Blah $userdata": }
    create_resources('user',$userdata)
  }

}
      
