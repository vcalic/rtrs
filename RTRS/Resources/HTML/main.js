class Stencil {

  constructor(data, templates) {
    try {
      this.data = JSON.parse(data);
    } catch (Exception) {
      console.log(Exception);
      throw "Could not parse data";
    }

    try {
      this.templates = JSON.parse(templates);
    } catch (Exception) {
      console.log(Exception);
      throw "Could not parse templates";
    }
  }

  process() {
    let time_source_func = Handlebars.compile(this.templates["timeSource"]);
    let title_func = Handlebars.compile(this.templates["title"]);
    let lead_func = Handlebars.compile(this.templates["lead"]);
    let body_func = Handlebars.compile(this.templates["body"]);
    let video_func = Handlebars.compile(this.templates["video"]);
    let article_func = Handlebars.compile(this.templates["article"]);
    let main_func = Handlebars.compile(this.templates["layout"]);

    let time = time_source_func(this.data);
    let title = title_func(this.data);
    let lead = lead_func(this.data);
    let body = body_func(this.data);
    let video = video_func(this.data);

    let result = {
      time: time,
      title: title,
      lead: lead,
      body: body,
      video: video
    };

    let article = article_func(result);
    let final = {article: article};
    return main_func(final);
  }
}

function createStencil(data, templates) {
  var stencil = new Stencil(data, templates);
  return stencil.process();
}
