# Create exp_soft directories/files
define grid_accounts::create_expsoft($dirs = {}, $files = {}){

  $yaml = inline_template('
---
<% @dirs.each_pair do |fqan, data |
   next if data["ensure"] == "absent" %>
   <%= fqan %>:
     ensure: "directory"
     path: "<%= data["path"] %>"
     owner: "<%= data["owner"] %>"
     group: "<%= data["group"] %>"
     mode: "<%= data["mode"] %>"
<% end -%>
<% @files.each_pair do |fqan, data |
   next if data["ensure"] == "absent" %>
   <%= fqan %>:
     path: "<%= data["path"] %>"
     source: "<%= data["source"] %>"
     owner: "<%= data["owner"] %>"
     group: "<%= data["group"] %>"
     mode: "<%= data["mode"] %>"
<% end -%>
  ')
  $dirdata = parseyaml($yaml)
  if $dirdata {
    create_resources('file',$dirdata)
  }
}
