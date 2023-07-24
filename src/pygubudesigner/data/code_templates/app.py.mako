<%inherit file="base.py.mako"/>
<%block name="project_paths" filter="trim">
PROJECT_PATH = pathlib.Path(__file__).parent
PROJECT_UI = PROJECT_PATH / "${project_name}"
</%block>

<%block name="class_definition" filter="trim">
class ${class_name}:
%if with_i18n_support and has_ttk_styles:
    def __init__(self, master=None, translator=None):
        self.builder = builder = pygubu.Builder(
            translator=translator,
            on_first_object=${ttk_styles_module}.setup_ttk_styles)
%elif with_i18n_support:
    def __init__(self, master=None, translator=None):
        self.builder = builder = pygubu.Builder(translator)
%elif has_ttk_styles:
    def __init__(self, master=None):
        self.builder = builder = pygubu.Builder(
            on_first_object=${ttk_styles_module}.setup_ttk_styles)
%else:
    def __init__(self, master=None):
        self.builder = builder = pygubu.Builder()
%endif
        builder.add_resource_path(PROJECT_PATH)
        builder.add_from_file(PROJECT_UI)
        # Main widget
        self.mainwindow:${widget_base_class} = builder.get_object("${main_widget}", master)
%if set_main_menu:
        # Main menu
        _main_menu = builder.get_object("${main_menu_id}", self.mainwindow)
        self.mainwindow.configure(menu=_main_menu)
%endif
    %if tkvariables:

        %for var in tkvariables:
        self.${var}:${tkvariablehints[var]} = None
        %endfor
        builder.import_variables(self)

    %endif
        builder.connect_callbacks(self)

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

    def get_widget(self, widget_id: str) -> tk.Widget:
        return self.builder.objects[widget_id].widget

    def instanceWidget(self, widgetName, instanceName=None, master=None, extra_init_args:dict=None) -> tk.Widget:
        if not instanceName:
            count = 0
            for k in (master if master else self.mainwindow).children:
                if k.startswith(widgetName):
                    count += 1
            instanceName = f"{widgetName}_{count + 1}"
        if not extra_init_args:
            extra_init_args = { "name": instanceName }
        elif "name" not in extra_init_args:
            extra_init_args["name"] = instanceName
        widget = self.builder.get_object(widgetName, master, extra_init_args)
        self.builder.objects[instanceName] = self.builder.objects.pop(widgetName)
        print(f"instanced '{widgetName}' as '{instanceName}'")
        return widget

    def run(self, center=False):
        if center:
            """ If `width` and `height` are set for the main widget,
            this is the only time TK returns them. """
            self.main_w = self.mainwindow.winfo_reqwidth()
            self.main_h = self.mainwindow.winfo_reqheight()
            self.center_map = self.mainwindow.bind("<Map>", self.center)
        self.mainwindow.mainloop()

${callbacks}\
</%block>
