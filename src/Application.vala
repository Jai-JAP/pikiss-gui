/*
* Copyright (c) 2011-2020 PiKISS-gui
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Kris Henriksen <krishenriksen.work@gmail.com>
*/

using Gtk;

public class PiKISS : Window {
    private void setup_apps(string directory, string category, Box box) {
        try {
            Dir dir = Dir.open (directory, 0);
            string? name = null;
            string pikiss = Config.pikiss-dir;
            while ((name = dir.read_name ()) != null) {
                string path = Path.build_filename (directory, name);

                //if (FileUtils.test (path, FileTest.IS_REGULAR) || FileUtils.test (path, FileTest.IS_EXECUTABLE)) {
                if (FileUtils.test (path, FileTest.IS_EXECUTABLE)) {
				    var button = new Button.with_label (name.replace (".sh", ""));
				    button.set_size_request(80, 32);
				    button.clicked.connect (() => {
	                    try {
	                        GLib.AppInfo.create_from_commandline ("x-terminal-emulator -e bash -c 'cd \"" + pikiss + "\" && \"" + directory + "/" + button.label + ".sh" + "\"'", null, GLib.AppInfoCreateFlags.NONE).launch(null,null);;
	                    } catch (GLib.Error e) {
	                        warning ("Error! Load application: " + e.message);
	                    }
				    });

				    box.pack_start (button, false, false, 3);
                }
            }
        } catch (FileError err) {
            message(err.message);
        }
    }	

    private void on_clicked_category (Box box, Box vbox) {
		GLib.List<weak Gtk.Widget> children = vbox.get_children ();
		bool toolbar = true;
		foreach (Gtk.Widget element in children) {
			// fix lazy
			if (!toolbar) {
				vbox.remove(element);
			}

			toolbar = false;
		}

    	// pack the box into the vbox
    	vbox.pack_start(box, false, false, 0);
    	vbox.show_all();
    }	

    public PiKISS () {
        this.title = "PiKISS (Pi Keeping It Simple, Stupid!)";
        this.window_position = WindowPosition.CENTER;
        this.set_default_size (640, 480);

        var scroller = new ScrolledWindow (null, null);
		scroller.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);

        var toolbar = new Toolbar ();
        toolbar.get_style_context ().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);

    	var vbox = new Box(Orientation.VERTICAL, 0);
        vbox.pack_start (toolbar, false, true, 0);

        try {
            //string directory = Environment.get_home_dir () + "/.local/share/applications";

            string directory = Config.PACKAGE_SHAREDIR + "/" + Config.PROJECT_NAME;

            Dir dir = Dir.open (directory, 0);
            string? name = null;

            while ((name = dir.read_name ()) != null) {
                string path = Path.build_filename (directory, name);

                if (FileUtils.test (path, FileTest.IS_DIR)) {
					var box = new Box(Orientation.VERTICAL, 0);

			    	var button = new Gtk.ToolButton(null, name);
			    	button.is_important = true;
			    	button.clicked.connect ( () => {
			    		this.on_clicked_category (box, vbox);
			    	});

                	toolbar.add(button);

                	// check dir for apps
                	setup_apps(path, name, box);
                }
            }
        } catch (FileError err) {
            message(err.message);
        }

        scroller.add (vbox);

    	add (scroller);

    	// Showing the window last so everything pops up at once.
    	scroller.show_all();
    }

    public static int main (string[] args) {
        Gtk.init (ref args);

        var window = new PiKISS ();

		try {
		    window.icon = IconTheme.get_default ().load_icon ("pikiss-gui", 48, 0);
		} catch (Error e) {
		    stderr.printf ("Could not load application icon: %s\n", e.message);
		}

        window.destroy.connect(Gtk.main_quit);
        window.show();

        Gtk.main ();
        return 0;
    }
}
