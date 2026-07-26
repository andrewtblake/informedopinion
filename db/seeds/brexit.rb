BREXIT_FACTS = [
  {
    prompt: "What share of valid votes in the 2016 EU referendum supported leaving the EU?",
    options: [ "48.1%", "51.9%", "61.9%" ],
    correct_option: 1,
    explanation: "Leave received 51.9% and Remain 48.1% of valid votes.",
    source_name: "UK Electoral Commission",
    source_url: "https://www.electoralcommission.org.uk/research-reports-and-data/our-reports-and-data-past-elections-and-referendums/eu-referendum/results-and-turnout-eu-referendum",
    evidence_direction: -1
  },
  {
    prompt: "What was turnout in the 2016 EU referendum?",
    options: [ "About 52%", "About 72%", "About 92%" ],
    correct_option: 1,
    explanation: "Turnout was 72.2%, with more than 33.5 million valid votes cast.",
    source_name: "UK Electoral Commission",
    source_url: "https://www.electoralcommission.org.uk/research-reports-and-data/our-reports-and-data-past-elections-and-referendums/eu-referendum/results-and-turnout-eu-referendum",
    evidence_direction: 0
  },
  {
    prompt: "When did the United Kingdom formally leave the European Union?",
    options: [ "23 June 2016", "31 January 2020", "1 January 2022" ],
    correct_option: 1,
    explanation: "The UK formally left on 31 January 2020 and then entered a transition period through 2020.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7960/",
    evidence_direction: 0
  },
  {
    prompt: "When did the post-Brexit Trade and Cooperation Agreement begin to apply?",
    options: [ "1 January 2021", "Immediately after the 2016 vote", "31 January 2020" ],
    correct_option: 0,
    explanation: "The TCA provisionally applied from 1 January 2021, after the transition period ended.",
    source_name: "UK Government",
    source_url: "https://www.gov.uk/government/publications/agreements-reached-between-the-united-kingdom-of-great-britain-and-northern-ireland-and-the-european-union/summary-explainer",
    evidence_direction: 0
  },
  {
    prompt: "Is the UK currently inside the EU single market and customs union?",
    options: [ "Inside both", "Outside both", "Inside the customs union only" ],
    correct_option: 1,
    explanation: "The UK left both frameworks; the TCA instead governs much of the current trading relationship.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: -1
  },
  {
    prompt: "Under the TCA, when can UK–EU trade in goods qualify for zero tariffs and zero quotas?",
    options: [ "All goods automatically", "When goods meet applicable rules of origin", "Only agricultural goods" ],
    correct_option: 1,
    explanation: "The agreement provides tariff- and quota-free goods trade where products satisfy origin requirements.",
    source_name: "UK Government",
    source_url: "https://www.gov.uk/government/publications/agreements-reached-between-the-united-kingdom-of-great-britain-and-northern-ireland-and-the-european-union/summary-explainer",
    evidence_direction: -1
  },
  {
    prompt: "Did zero tariffs under the TCA remove all new barriers to UK–EU goods trade?",
    options: [ "Yes", "No; customs, regulatory and origin formalities remain", "Only for digital services" ],
    correct_option: 1,
    explanation: "Leaving the single market and customs union introduced non-tariff barriers even where tariffs are zero.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: 1
  },
  {
    prompt: "What share of all UK exports went to the EU in 2025?",
    options: [ "About 21%", "About 41%", "About 71%" ],
    correct_option: 1,
    explanation: "The EU bought 41% of UK goods and services exports in 2025.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: 1
  },
  {
    prompt: "What share of all UK imports came from the EU in 2025?",
    options: [ "About 20%", "About 35%", "About 50%" ],
    correct_option: 2,
    explanation: "The EU supplied 50% of UK imports in 2025.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: 1
  },
  {
    prompt: "How did real UK goods exports to the EU in 2025 compare with 2019?",
    options: [ "14% lower", "Unchanged", "28% higher" ],
    correct_option: 0,
    explanation: "They were 14% below the 2019 level in real terms, though the pandemic and global shocks also affected trade.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: 1
  },
  {
    prompt: "How did real UK services exports to the EU in 2025 compare with 2019?",
    options: [ "28% higher", "14% lower", "50% lower" ],
    correct_option: 0,
    explanation: "Services exports to the EU grew strongly and stood 28% above their 2019 level in real terms.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: -1
  },
  {
    prompt: "What does the Office for Budget Responsibility assume the post-Brexit trading relationship will do to long-run UK productivity relative to remaining?",
    options: [ "Raise it by 4%", "Reduce it by 4%", "Have exactly no effect" ],
    correct_option: 1,
    explanation: "The independent OBR maintains a forecast assumption of a 4% long-run productivity reduction relative to EU membership.",
    source_name: "Office for Budget Responsibility",
    source_url: "https://obr.uk/forecasts-in-depth/the-economy-forecast/brexit-analysis/",
    evidence_direction: 1
  },
  {
    prompt: "What long-run effect does the OBR assume Brexit will have on UK imports and exports relative to remaining in the EU?",
    options: [ "Both about 15% lower", "Both about 15% higher", "No difference" ],
    correct_option: 0,
    explanation: "The OBR assumes both import and export volumes will be around 15% lower than otherwise.",
    source_name: "Office for Budget Responsibility",
    source_url: "https://obr.uk/box/how-are-our-brexit-forecasting-assumptions-performing/",
    evidence_direction: 1
  },
  {
    prompt: "Is the OBR's 4% figure an estimate that today's measured GDP is exactly 4% lower solely because of Brexit?",
    options: [ "Yes", "No; it is a long-run productivity forecast relative to a counterfactual", "It is an estimate of inflation" ],
    correct_option: 1,
    explanation: "It is a modelled long-run difference from a hypothetical path in which the UK remained, not a direct reading from current GDP.",
    source_name: "Office for Budget Responsibility",
    source_url: "https://obr.uk/forecasts-in-depth/the-economy-forecast/brexit-analysis/",
    evidence_direction: -1
  },
  {
    prompt: "Can post-2020 changes in UK–EU trade be attributed only to Brexit?",
    options: [ "Yes", "No; the pandemic, Ukraine war and supply-chain disruption also mattered", "Only import changes can" ],
    correct_option: 1,
    explanation: "Official analysis cautions that several major shocks overlapped, complicating causal comparisons.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: -1
  },
  {
    prompt: "What happened to free movement between the UK and EU at the end of 2020?",
    options: [ "It continued unchanged", "It ended and the UK introduced a points-based system", "It expanded worldwide" ],
    correct_option: 1,
    explanation: "EU free movement ended on 31 December 2020; most new EU arrivals became subject to UK immigration rules.",
    source_name: "UK Government",
    source_url: "https://www.gov.uk/guidance/the-uks-points-based-immigration-system-information-for-eu-citizens",
    evidence_direction: -1
  },
  {
    prompt: "As an EU citizen, what general right accompanies EU membership?",
    options: [ "A right to live, work and study in other EU countries", "Automatic citizenship of every country", "A right to avoid all national taxes" ],
    correct_option: 0,
    explanation: "EU citizenship includes free-movement rights to live, work and study across member states, subject to treaty conditions.",
    source_name: "European Commission",
    source_url: "https://ec.europa.eu/justice/citizenship/index_en.html",
    evidence_direction: 1
  },
  {
    prompt: "Did Brexit remove the Common Travel Area rights of Irish citizens in the UK?",
    options: [ "Yes", "No", "Only in Northern Ireland" ],
    correct_option: 1,
    explanation: "Irish citizens remain protected by the Common Travel Area and generally do not need permission to live and work in the UK.",
    source_name: "UK Government",
    source_url: "https://www.gov.uk/government/publications/uk-points-based-immigration-system-further-details-statement/uk-points-based-immigration-system-further-details-statement",
    evidence_direction: -1
  },
  {
    prompt: "By the end of 2025, approximately how many people had received UK status through the EU Settlement Scheme?",
    options: [ "580,000", "5.8 million", "58 million" ],
    correct_option: 1,
    explanation: "The Home Office reported status for more than 5.8 million EU, EEA and Swiss citizens and eligible family members.",
    source_name: "UK Government",
    source_url: "https://www.gov.uk/government/publications/eu-settlement-scheme-euss-status-automation-update-april-2026/eu-settlement-scheme-euss-status-automation-update",
    evidence_direction: 0
  },
  {
    prompt: "As an EU member, did the UK pay more into the EU budget than the public sector received directly?",
    options: [ "Yes, it was a net contributor", "No, it was always a net recipient", "Contributions were exactly equal" ],
    correct_option: 0,
    explanation: "The UK was a net contributor, although estimates vary depending on which direct EU payments to UK organisations are counted.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7886/",
    evidence_direction: -1
  },
  {
    prompt: "What was the UK's average annual net EU budget contribution in 2016–2019 after counting direct EU funding to UK organisations?",
    options: [ "About £0.7 billion", "About £7–7.5 billion", "About £70 billion" ],
    correct_option: 1,
    explanation: "The Commons Library estimates roughly £7–7.5 billion annually using this broader treatment of receipts.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7886/",
    evidence_direction: -1
  },
  {
    prompt: "Does the UK's former net EU budget contribution measure the total economic cost or benefit of membership?",
    options: [ "Yes", "No", "Only in election years" ],
    correct_option: 1,
    explanation: "It measures direct budget flows, not wider effects such as trade, investment, regulation or migration.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7886/",
    evidence_direction: 1
  },
  {
    prompt: "Did leaving the EU immediately end every UK payment to EU institutions?",
    options: [ "Yes", "No; the financial settlement and programme participation involve payments", "Only Scotland continued paying" ],
    correct_option: 1,
    explanation: "The UK continues to meet pre-existing commitments through the withdrawal settlement and pays to join selected programmes.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7886/",
    evidence_direction: 0
  },
  {
    prompt: "Can the UK make its own trade agreements now that it is outside the EU common commercial policy?",
    options: [ "Yes", "No", "Only with Commonwealth countries" ],
    correct_option: 0,
    explanation: "The UK now negotiates its own trade agreements, including agreements with Japan, Australia and New Zealand.",
    source_name: "UK Government",
    source_url: "https://www.gov.uk/guidance/uk-trade-agreements-in-effect",
    evidence_direction: -1
  },
  {
    prompt: "What long-run GDP gain does the UK Government estimate for the Australia free-trade agreement?",
    options: [ "About 0.08%", "About 4%", "About 15%" ],
    correct_option: 0,
    explanation: "The Government's impact assessment estimated UK GDP would be about 0.08% higher in the long run than without the agreement.",
    source_name: "UK Government Impact Assessment",
    source_url: "https://www.gov.uk/government/publications/uk-australia-fta-impact-assessment",
    evidence_direction: 1
  },
  {
    prompt: "After Brexit, which body has final authority to make most laws applying in the UK?",
    options: [ "The UK Parliament and devolved legislatures within their powers", "The European Commission alone", "The European Central Bank" ],
    correct_option: 0,
    explanation: "EU law no longer has general supremacy in the UK, although treaty obligations and retained or assimilated law still shape domestic rules.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-8375/",
    evidence_direction: -1
  },
  {
    prompt: "Can the UK ignore the rules of the TCA without possible consequences?",
    options: [ "Yes", "No; treaty dispute and rebalancing mechanisms can apply", "Only rules about fisheries are binding" ],
    correct_option: 1,
    explanation: "Like other international agreements, the TCA creates reciprocal obligations backed by governance and dispute mechanisms.",
    source_name: "UK–EU Trade and Cooperation Agreement",
    source_url: "https://www.gov.uk/government/publications/ukeu-and-eaec-trade-and-cooperation-agreement-ts-no82021",
    evidence_direction: 1
  },
  {
    prompt: "Did the UK leave the European Convention on Human Rights when it left the EU?",
    options: [ "Yes", "No", "Only England remained" ],
    correct_option: 1,
    explanation: "The ECHR belongs to the separate Council of Europe, not the EU; Brexit did not end UK membership.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-9958/",
    evidence_direction: 0
  },
  {
    prompt: "Did Brexit end all UK participation in EU research programmes?",
    options: [ "Yes", "No; the UK associated to Horizon Europe from 2024", "The UK was never involved" ],
    correct_option: 1,
    explanation: "The UK became an associated country to Horizon Europe, allowing eligible UK researchers to participate under agreed financial terms.",
    source_name: "European Commission",
    source_url: "https://research-and-innovation.ec.europa.eu/strategy/strategy-research-and-innovation/europe-world/international-cooperation/association-horizon-europe/united-kingdom_en",
    evidence_direction: -1
  },
  {
    prompt: "Under the post-Brexit settlement, are goods moving from Great Britain to Northern Ireland treated exactly like goods moving within Great Britain?",
    options: [ "Yes, in every case", "No; special arrangements apply to protect the open Irish border and EU single market", "Only postal items may move" ],
    correct_option: 1,
    explanation: "The Windsor Framework creates differentiated arrangements because Northern Ireland shares a land border with the EU.",
    source_name: "UK Government Windsor Framework",
    source_url: "https://www.gov.uk/government/publications/the-windsor-framework",
    evidence_direction: 1
  }
].freeze
