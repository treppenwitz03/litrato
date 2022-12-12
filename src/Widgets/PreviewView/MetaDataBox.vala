public class Album.MetaDataBox : Gtk.Box {
    private Gtk.Label meta_title;
    private Gtk.Label meta_size;
    private Gtk.Label meta_time;
    private Gtk.Label meta_date;
    private Gtk.Label meta_filepath;

    public MetaDataBox () {
        Object (
            orientation: Gtk.Orientation.VERTICAL,
            spacing: 0,
            vexpand: true,
            margin_start: 6,
            margin_end: 6,
            margin_top: 6,
            margin_bottom: 6
        );
    }

    construct {
        meta_title = new Gtk.Label ("") {
            wrap = true,
            wrap_mode = Pango.WrapMode.CHAR,
            max_width_chars = 10,
            margin_top = 10,
            margin_bottom = 20
        };
        meta_title.add_css_class (Granite.STYLE_CLASS_H2_LABEL);

        meta_size = new Gtk.Label ("") {
            xalign = -1,
            use_markup = true
        };

        meta_time = new Gtk.Label ("") {
            xalign = -1,
            use_markup = true
        };

        meta_date = new Gtk.Label ("") {
            xalign = -1,
            use_markup = true
        };

        meta_filepath = new Gtk.Label ("") {
            xalign = -1,
            use_markup = true,
            wrap = true,
            wrap_mode = Pango.WrapMode.CHAR,
            max_width_chars = 15,
            margin_top = 20
        };

        append (meta_title);
        append (meta_date);
        append (meta_time);
        append (meta_filepath);
        append (meta_size);
    }

    public void update_properties (Album.ImageFlowBoxChild child) {
        meta_title.label = child.file.get_basename ();
        meta_time.label = "<b>Time modified: </b>%s".printf (child.time);
        meta_date.label = "<b>Date modified: </b>%s".printf (child.date);
        meta_size.label = "<b>File Size: </b>%s".printf (child.size_data);
        meta_filepath.label = "<b>Path: </b>%s".printf (child.file.get_path ());
    }
}
