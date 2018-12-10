# Create exp_soft directories/files
define grid_accounts::create_expsoft($top_dir = "", $dirs = {}, $files = {}){

  if $top_dir == "" {
    return
  }

  exec {"expsoft_top_dir":
    command => "/bin/mkdir -p ${top_dir}",
  }
  $yaml = inline_template('
---
<% @dirs.each_pair do |fqan, data |
   next if data["ensure"] == "absent" %>
   <%= fqan %>:
     ensure: "directory"
     path: "<%= top_dir %><%= data["path"] %>"
     owner: "<%= data["owner"] %>"
     group: "<%= data["group"] %>"
     mode: "<%= data["mode"] %>"
<% end -%>
<% @files.each_pair do |fqan, data |
   next if data["ensure"] == "absent" %>
   <%= fqan %>:
     path: "<%= top_dir %><%= data["path"] %>"
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
