# grid-mapfile section
define grid_accounts::gmap ( $type = "grid", $role_maps = {}){

  if $type == "grid" {

    concat {"/etc/grid-security/$title":
      ensure => "present"
    }

    $yaml = inline_template('
---
<% @role_maps.each_pair do |fqan, data |
   next if data["ensure"] == "absent"
   fqanr = fqan =~ /Role=/i ? fqan : fqan+"/Role=NULL" %>
   <%= fqan %>_grid:
     target: "/etc/grid-security/<%= @title %>"
     content: "\"<%= fqanr %>/Capability=NULL\" .<%= data["group"] %>\n\"<%= fqan %>\" .<%= data["group"] %>\n"
   <% end -%>
    ')

    $filedata = parseyaml($yaml)
#    notify {"grid-mapfile ($filedata)": }
    create_resources('concat::fragment',$filedata)

    file { "/etc/grid-security/local-grid-mapfile":
      ensure => "present"
    }
  }

# groupmapfile section
  if $type == "group" {

    concat {"/etc/grid-security/$title":
      ensure => "present"
    }

    $yaml = inline_template('
---
<% @role_maps.each_pair do |fqan, data |
   next if data["ensure"] == "absent"
   fqanr = fqan =~ /Role=/i ? fqan : fqan+"/Role=NULL" %>
   <%= fqan %>_group:
     target: "/etc/grid-security/<%= @title %>"
     content: "\"<%= fqanr %>/Capability=NULL\" <%= data["group"] %>\n\"<%= fqan %>\" <%= data["group"] %>\n"
   <% end -%>
    ')

    $filedata = parseyaml($yaml)
#    notify {"groupmapfile ($filedata)": }
    create_resources('concat::fragment',$filedata)
  }
  
  if $type == "dir" {

    $yaml = inline_template('
---
"/etc/grid-security/<%= @title %>":
  ensure: directory
<% @role_maps.each_pair do |fqan, data |
  next if data["ensure"] == "absent" %>
  <% uid_fl = data["uid_range"].split("-");
    uids = (uid_fl[0]..uid_fl[1]).to_a;
    (1..data["users_num"]).each do |i| %>
  <% user = sprintf("%s%#03i",data["group"],i) %>
"/etc/grid-security/<%= @title %>/<%= user %>":
  ensure: <%= data["ensure"] %>
  require: File[/etc/grid-security/<%= @title %>]
  <% end %>
<% end -%>
  ')
#    notify {"$yaml": }
    $mapdirdata = parseyaml($yaml)
#    notify {"Blah Blah $mapdirdata": }
    if $mapdirdata {
      create_resources('file',$mapdirdata)
    }
  }           
}
  
