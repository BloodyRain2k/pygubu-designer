<%inherit file="base.py.mako"/>

<%block name="class_definition" filter="trim">
class ${class_name}:
%if with_i18n_support:
    def __init__(self, master=None, translator=None):
        _ = translator
        if translator is None:
            _ = lambda x: x
%else:
    def __init__(self, master=None):
%endif
        # build ui
${widget_code}
        # Main widget
        self.mainwindow = ${target_code_id}
%if set_main_menu:
        # Main menu
        _main_menu = self.create_${main_menu_id}(self.mainwindow)
        self.mainwindow.configure(menu=_main_menu)
%endif

    def center(self, widget):
        # check if widget is set and not an event
        if not widget or not hasattr(widget, "tk"):
            widget = self.mainwindow
        wm_min = widget.wm_minsize()
        wm_max = widget.wm_maxsize()
        screen_w = widget.winfo_screenwidth()
        screen_h = widget.winfo_screenheight()
        """ `winfo_width` / `winfo_height` at this point return `geometry` size if set. """
        x_min = min(screen_w, wm_max[0],
                    max(self.main_w, wm_min[0],
                        widget.winfo_width(),
                        widget.winfo_reqwidth()
                    ))
        y_min = min(screen_h, wm_max[1],
                    max(self.main_h, wm_min[1],
                        widget.winfo_height(),
                        widget.winfo_reqheight()
                    ))
        x = screen_w - x_min
        y = screen_h - y_min
        size = f"{x_min}x{y_min}+{x // 2}+{y // 2}"
        # clean up state from on-run call
        if self.main_w > 0 or self.main_h > 0:
            widget.unbind("<Map>", self.center_map)
            self.main_w = 0
            self.main_h = 0
        widget.geometry(size)

    def run(self, center=False):
        if center:
            """ If `width` and `height` are set for the main widget,
            this is the only time TK returns them. """
            self.main_w = self.mainwindow.winfo_reqwidth()
            self.main_h = self.mainwindow.winfo_reqheight()
            self.center_map = self.mainwindow.bind("<Map>", self.center)
        self.mainwindow.mainloop()

${methods}\

${callbacks}\
</%block>
