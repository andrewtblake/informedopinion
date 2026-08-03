class SiteIdentity
  Site = Data.define(
    :key,
    :name,
    :short_mark,
    :variant,
    :theme_color,
    :description,
    :favicon_prefix,
    :copy
  ) do
    def alternative?
      key == :what_do_you_think
    end
  end

  PRIMARY = Site.new(
    key: :informed_opinion,
    name: "Informed Opinion",
    short_mark: "io",
    variant: nil,
    theme_color: "#102a2b",
    description: "Discover how well the evidence supports the opinions you hold.",
    favicon_prefix: "",
    copy: {
      nav_opinions: "My opinions",
      nav_proposals: "Proposals",
      nav_help: "Help",
      create_account: "Create account",
      footer_tagline: "Evidence gives an opinion weight.",
      opinion_heading: "Which response best reflects your view?",
      opinion_gate: "Create a free account to register your response and keep your knowledge score.",
      opinion_register: "Register my opinion",
      continue_quiz: "Continue knowledge check →",
      initial_weight: "Your starting weight will be 0% until you answer facts.",
      quiz_label: "knowledge check",
      quiz_leave: "← Leave quiz",
      opinions_kicker: "Personal record",
      opinions_heading: "My opinions",
      opinions_intro: "Your registered positions and the knowledge weight currently assigned to each.",
      sign_in_intro: "Return to your registered opinions and knowledge checks.",
      registration_intro: "An account associates your opinions with your answers and preserves your progress.",
      account_intro: "Review what is associated with your account, record participation consent, or delete the account and its participation data.",
      account_consent_heading: "Review the current participation terms",
      account_consent_explanation: "Some topic responses may reveal political opinions or other sensitive beliefs. They are stored against your private account so your knowledge-weighted opinion can be calculated. Your name and individual answers are not published.",
      account_terms_label: "participation terms",
      account_consent_decision: "before deciding.",
      account_record_kicker: "Account record",
      account_opinions_label: "Registered opinions",
      account_reactions_label: "Question reactions",
      account_reports_label: "Fact reports",
      account_record_note: "The public aggregate uses your opinion position and topic-specific knowledge weight. It does not display your name, email address, individual answers or individual opinion record.",
      account_deletion_explanation: "This removes the account, registered opinions, fact answers, reactions, reports and proposals from the live database. Published editorial questions created from an approved proposal remain part of the public question bank, without a public attribution to you.",
      account_deletion_warning: "The action cannot be undone. Confirm it with your current password and the word",
      account_deletion_confirmation: "Permanently delete your account and participation data?",
      retained_heading: "What is retained",
      consent_text: "I explicitly consent to Informed Opinion recording and using my topic opinions and knowledge-check answers as described in the privacy notice. I understand that some responses may reveal political opinions or other sensitive beliefs, and that I can withdraw consent by deleting my account.",
      proposals_kicker: "Reader proposals",
      proposals_heading: "Proposals",
      proposals_intro: "Suggest a new opinion question and follow the status of questions you have already proposed."
    }
  )

  ALTERNATIVE = Site.new(
    key: :what_do_you_think,
    name: "What's Your View?",
    short_mark: "w?",
    variant: :what_do_you_think,
    theme_color: "#1769d2",
    description: "See where people stand on disputed questions—and how much factual knowledge lies behind the result.",
    favicon_prefix: "what-do-you-think-",
    copy: {
      nav_opinions: "Your opinions",
      nav_proposals: "Suggest a question",
      nav_help: "How it works",
      create_account: "Join in",
      footer_tagline: "See what people think—and what they know.",
      opinion_heading: "Where do you stand?",
      opinion_gate: "Create a free account to give your view and keep your progress.",
      opinion_register: "Give my view",
      continue_quiz: "Continue with the facts",
      initial_weight: "Your view starts at 0% weight and gains weight as you answer fact questions correctly.",
      quiz_label: "the facts",
      quiz_leave: "← Leave for now",
      opinions_kicker: "Your topics",
      opinions_heading: "Your opinions",
      opinions_intro: "See your views, progress and current knowledge weight for each topic.",
      sign_in_intro: "Return to your opinions and continue where you left off.",
      registration_intro: "Keep your opinions, answers and progress together in one account.",
      account_intro: "Review what's linked to your account, confirm your consent to take part, or permanently delete your account and its data.",
      account_consent_heading: "Review the current terms and your consent",
      account_consent_explanation: "Some answers may reveal political opinions or other sensitive beliefs. They are stored with your private account so the site can calculate how much weight to give your opinion. Your name and individual answers are not published.",
      account_terms_label: "terms for taking part",
      account_consent_decision: "before deciding whether to continue.",
      account_record_kicker: "Your account",
      account_opinions_label: "Opinions recorded",
      account_reactions_label: "Likes and dislikes",
      account_reports_label: "Facts reported",
      account_record_note: "The public result uses your opinion and its knowledge weight for that topic. It does not show your name, email address, individual answers or individual opinion.",
      account_deletion_explanation: "This permanently removes your account, opinions, fact answers, likes and dislikes, reports and proposals. Questions published after one of your proposals was approved will remain on the site, but your name will not be shown.",
      account_deletion_warning: "This cannot be undone. Confirm the deletion with your current password and the word",
      account_deletion_confirmation: "Permanently delete your account and its data?",
      retained_heading: "What's retained",
      consent_text: "I explicitly consent to this service recording and using my topic opinions and fact-question answers as described in the privacy notice. I understand that some responses may reveal political opinions or other sensitive beliefs, and that I can withdraw consent by deleting my account.",
      proposals_kicker: "Your suggestions",
      proposals_heading: "Suggest a question",
      proposals_intro: "Send us a disputed question you think belongs on the site, and check what has happened to earlier suggestions."
    }
  )

  LOCAL_ALTERNATIVE_HOSTS = %w[whatsyourview.localhost wyv.localhost].freeze

  class << self
    def fetch(key)
      key.to_s == ALTERNATIVE.key.to_s ? ALTERNATIVE : PRIMARY
    end

    def for_host(host)
      return ALTERNATIVE if alternative_enabled? && alternative_hosts.include?(host.to_s.downcase)

      PRIMARY
    end

    def alternative_enabled?
      Rails.env.local? || ActiveModel::Type::Boolean.new.cast(ENV["ALTERNATE_SITE_ENABLED"])
    end

    def alternative_hosts
      configured = ENV["ALTERNATE_APP_HOST"].to_s.downcase.presence
      hosts = configured ? [ configured, "www.#{configured}" ] : []
      Rails.env.local? ? hosts | LOCAL_ALTERNATIVE_HOSTS : hosts
    end
  end
end
