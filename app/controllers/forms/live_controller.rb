class Forms::LiveController < Forms::BaseController
  after_action :verify_authorized
  def show_form
    authorize current_form, :can_view_form?
    render template: "live/show_form", locals: { form_metadata: current_form, form: current_live_form, metrics_data: }
  end

  def show_pages
    authorize current_form, :can_view_form?
    render template: "live/show_pages", locals: { form: current_live_form }
  end

  def metrics_data
    # If the form went live today, there won't be any metrics to show
    today = Time.zone.today
    form_is_new = Time.zone.parse(current_live_form.live_at.to_s) >= today.midnight

    weekly_submissions = form_is_new ? 0 : CloudWatchService.week_submissions(form_id: current_live_form.id)
    weekly_starts = form_is_new ? 0 : CloudWatchService.week_starts(form_id: current_live_form.id)

    {
      weekly_submissions:,
      weekly_starts:,
      form_is_new:,
    }
  rescue Aws::CloudWatch::Errors::ServiceError
    nil
  end

private

  def current_live_form
    Form.find_live(params[:form_id])
  end
end
