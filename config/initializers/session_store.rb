Rails.application.config.session_store :cookie_store,
                                       key: '_session_id',
                                       expire_after: 1.week,
                                       secure: Rails.env.production?,
                                       same_site: :lax
