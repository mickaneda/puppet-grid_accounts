define grid_accounts::delete_expsoft($dirs = {}, $files = {}){

####### Delete exp dirs/files
  $dirs_yaml = inline_template('
---
<% @files.each_pair do |fqan, data |
  next if data["ensure"] != "absent" %>
  <%= fqdn %>:
    ensure: <%= data["ensure"] %>
    path: <%= data["path"] %>
    recurse: true
    purge: true
    force: true
<% end -%>
<% @dirs.each_pair do |fqan, data |
  next if data["ensure"] != "absent" %>
  <%= fqdn %>:
    ensure: <%= data["ensure"] %>
    path: <%= data["path"] %>
    recurse: true
    purge: true
    force: true
<% end -%>
  ')
   $dirdata = parseyaml($dirs_yaml)
   if $dirdata {
   create_resources('file',$dirdata)
  }
}
