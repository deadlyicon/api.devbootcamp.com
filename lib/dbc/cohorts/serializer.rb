class Dbc::Cohorts::Serializer < Dbc::Serializer

  def serialize cohort

    data = {
      "id"          => cohort.id,
      "name"        => cohort.name,
      "location"    => cohort.location.name,
      "in_session"  => cohort.in_session,
      "start_date"  => cohort.start_date,
      "email"       => cohort.email,
      "visible"     => cohort.visible,
      "slug"        => cohort.slug,
      "created_at"  => cohort.created_at,
      "updated_at"  => cohort.updated_at,
    }

    data["errors"] = cohort.errors.full_messages if cohort.errors.present?

    return data

  end

end
