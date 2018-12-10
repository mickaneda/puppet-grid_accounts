####### Delete exp dirs/files
define grid_accounts::delete_expsoft($top_dir = "", $dirs = {}, $files = {}){

  $dirs_yaml = inline_template('
---
<% @files.each_pair do |fqan, data |
  next if data["ensure"] != "absent" %>
  <%= fqan %>:
    ensure: "<%= top_dir %>/<%= data["ensure"] %>"
    path: "<%= data["path"] %>"
    recurse: true
    purge: true
    force: true
<% end -%>
<% @dirs.each_pair do |fqan, data |
  next if data["ensure"] != "absent" %>
  <%= fqan %>:
    ensure: "<%= top_dir %>/<%= data["ensure"] %>"
    path: "<%= data["path"] %>"
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

