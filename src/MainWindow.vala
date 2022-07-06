public class Album.MainWindow : Gtk.ApplicationWindow {
    public Album.PreviewPage preview_page { get; set; }
    public TransitionStack transition_stack { get; set; }
    public Adw.Leaflet leaflet { get; set; }

    public MainWindow (Album.Application app) {
        Object (application: app);
    }

    construct {
        default_width = 960;
        default_height = 640;
        titlebar = new Gtk.Label ("") { visible = false };
        icon_name = "io.elementary.photos";

        preview_page = new Album.PreviewPage ();

        var date_label = new Granite.HeaderLabel ("Album");
        var images_header = new Gtk.HeaderBar () {
            decoration_layout = ":maximize",
            show_title_buttons = true,
            valign = Gtk.Align.START,
            halign = Gtk.Align.FILL,
            title_widget = date_label
        };
        images_header.add_css_class ("titlebar");
        images_header.add_css_class (Granite.STYLE_CLASS_FLAT);
        images_header.add_css_class (Granite.STYLE_CLASS_DEFAULT_DECORATION);

        var images_stack = new Gtk.Stack () {
            transition_type = Gtk.StackTransitionType.SLIDE_UP_DOWN,
            hexpand = true,
            vexpand = true
        };

        var folders = Album.Application.settings.get_strv ("sidebar-folders");
        if (folders.length == 0) {
            var home_folder = Environment.get_variable ("HOME");
            folders += home_folder;
            folders += home_folder + "/Pictures";
            folders += home_folder + "/Pictures/Screenshots/";
            folders += home_folder + "/Downloads";

            Album.Application.settings.set_strv ("sidebar-folders", folders);
        }

        for (var index = 0; index < folders.length; index++) {
            images_stack.add_child (new Album.LocationImages (folders[index], index, this));
        }

        var images_view = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
            vexpand = true,
            hexpand = true
        };
        images_view.append (images_header);
        images_view.append (images_stack);
        images_view.add_css_class (Granite.STYLE_CLASS_VIEW);

        var locations_header = new Gtk.HeaderBar () {
            decoration_layout = "close:",
            show_title_buttons = true,
            valign = Gtk.Align.START,
            halign = Gtk.Align.FILL,
            title_widget = new Gtk.Label ("") { visible = false }
        };
        locations_header.add_css_class ("titlebar");
        locations_header.add_css_class (Granite.STYLE_CLASS_FLAT);
        locations_header.add_css_class (Granite.STYLE_CLASS_DEFAULT_DECORATION);

        var locations = new Granite.SettingsSidebar (images_stack) {
            vexpand = true
        };

        var locations_sidebar = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
            vexpand = true
        };
        locations_sidebar.append (locations_header);
        locations_sidebar.append (locations);
        locations_sidebar.add_css_class (Granite.STYLE_CLASS_SIDEBAR);

        leaflet = new Adw.Leaflet () {
            transition_type = Adw.LeafletTransitionType.SLIDE
        };
        leaflet.append (locations_sidebar);
        leaflet.append (images_view);
        leaflet.visible_child = images_view;

        leaflet.notify["folded"].connect (() => {
            print ("%s\n", leaflet.folded.to_string ());
        });

        transition_stack = new TransitionStack ();
        transition_stack.add (leaflet);
        transition_stack.add (preview_page);

        child = transition_stack;

        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();

        gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;

        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        });
    }
}
