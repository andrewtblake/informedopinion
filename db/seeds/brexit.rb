BREXIT_FACTS = [
  {
    prompt: "What percentage of valid votes in the 2016 referendum were cast for leaving the European Union?",
    options: [ "51.9%", "55.4%", "48.1%", "50.6%" ],
    correct_option: 0,
    explanation: "Leave received 51.9% and Remain 48.1% of valid votes.",
    source_name: "UK Electoral Commission",
    source_url: "https://www.electoralcommission.org.uk/research-reports-and-data/our-reports-and-data-past-elections-and-referendums/eu-referendum/results-and-turnout-eu-referendum",
    evidence_direction: -1
  },
  {
    prompt: "What proportion of the eligible electorate voted in the 2016 EU referendum?",
    options: [ "65.8%", "72.2%", "78.6%", "69.1%" ],
    correct_option: 1,
    explanation: "Turnout was 72.2%, with more than 33.5 million valid votes cast.",
    source_name: "UK Electoral Commission",
    source_url: "https://www.electoralcommission.org.uk/research-reports-and-data/our-reports-and-data-past-elections-and-referendums/eu-referendum/results-and-turnout-eu-referendum",
    evidence_direction: 0
  },
  {
    prompt: "On which date did the United Kingdom legally cease to be an EU Member State?",
    options: [ "29 March 2019", "31 December 2020", "31 January 2020", "23 June 2016" ],
    correct_option: 2,
    explanation: "The UK formally left on 31 January 2020 and then entered a transition period through 2020.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7960/",
    evidence_direction: 0
  },
  {
    prompt: "When did the UK–EU Trade and Cooperation Agreement begin provisional application?",
    options: [ "1 February 2020", "1 July 2020", "1 May 2021", "1 January 2021" ],
    correct_option: 3,
    explanation: "The TCA provisionally applied from 1 January 2021, after the transition period ended.",
    source_name: "UK Government",
    source_url: "https://www.gov.uk/government/publications/agreements-reached-between-the-united-kingdom-of-great-britain-and-northern-ireland-and-the-european-union/summary-explainer",
    evidence_direction: 0
  },
  {
    prompt: "Which description matches the UK's present relationship with the EU single market and customs union?",
    options: [ "The UK is outside both", "The UK remains in the single market but not the customs union", "The UK remains in the customs union but not the single market", "Great Britain remains in both while Northern Ireland left both" ],
    correct_option: 0,
    explanation: "The UK left both frameworks; the TCA instead governs much of the current trading relationship.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: -1
  },
  {
    prompt: "What must a UK or EU good ordinarily satisfy to receive the TCA's zero-tariff treatment?",
    options: [ "It must be transported directly by sea", "It must meet the agreement's rules of origin", "Its exporter must be a publicly listed company", "Its value must be below a fixed consignment limit" ],
    correct_option: 1,
    explanation: "The agreement provides tariff- and quota-free goods trade where products satisfy origin requirements.",
    source_name: "UK Government",
    source_url: "https://www.gov.uk/government/publications/agreements-reached-between-the-united-kingdom-of-great-britain-and-northern-ireland-and-the-european-union/summary-explainer",
    evidence_direction: -1
  },
  {
    prompt: "What changed for UK–EU goods trade even where the TCA set the tariff at zero?",
    options: [ "Every product became subject to a numerical quota", "VAT ceased to apply to imported goods", "Customs, regulatory and origin formalities increased", "EU product standards stopped applying to goods sold in the EU" ],
    correct_option: 2,
    explanation: "Leaving the single market and customs union introduced non-tariff barriers even where tariffs are zero.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: 1
  },
  {
    prompt: "What share of total UK goods and services exports went to the EU in 2025?",
    options: [ "34%", "53%", "47%", "41%" ],
    correct_option: 3,
    explanation: "The EU bought 41% of UK goods and services exports in 2025.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: 1
  },
  {
    prompt: "What share of total UK goods and services imports came from the EU in 2025?",
    options: [ "50%", "43%", "57%", "36%" ],
    correct_option: 0,
    explanation: "The EU supplied 50% of UK imports in 2025.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: 1
  },
  {
    prompt: "In real terms, how did UK goods exports to the EU in 2025 compare with their 2019 level?",
    options: [ "They were 6% higher", "They were 14% lower", "They were 22% lower", "They were 3% lower" ],
    correct_option: 1,
    explanation: "They were 14% below the 2019 level in real terms, though the pandemic and global shocks also affected trade.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: 1
  },
  {
    prompt: "In real terms, how did UK services exports to the EU in 2025 compare with 2019?",
    options: [ "They were 11% lower", "They were 16% higher", "They were 28% higher", "They were approximately unchanged" ],
    correct_option: 2,
    explanation: "Services exports to the EU grew strongly and stood 28% above their 2019 level in real terms.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: -1
  },
  {
    prompt: "What long-run productivity effect does the Office for Budget Responsibility assume for the post-Brexit trading relationship, relative to remaining in the EU?",
    options: [ "A 2% increase", "No material change", "A 7% reduction", "A 4% reduction" ],
    correct_option: 3,
    explanation: "The independent OBR maintains a forecast assumption of a 4% long-run productivity reduction relative to EU membership.",
    source_name: "Office for Budget Responsibility",
    source_url: "https://obr.uk/forecasts-in-depth/the-economy-forecast/brexit-analysis/",
    evidence_direction: 1
  },
  {
    prompt: "What long-run change in UK import and export volumes does the OBR assume relative to a remain-in-the-EU counterfactual?",
    options: [ "Both will be about 15% lower", "Imports will be lower but exports unchanged", "Both will be about 5% higher", "Exports will be lower but imports higher" ],
    correct_option: 0,
    explanation: "The OBR assumes both import and export volumes will be around 15% lower than otherwise.",
    source_name: "Office for Budget Responsibility",
    source_url: "https://obr.uk/box/how-are-our-brexit-forecasting-assumptions-performing/",
    evidence_direction: 1
  },
  {
    prompt: "What exactly is the OBR's widely cited 4% Brexit productivity figure?",
    options: [ "A direct measurement of GDP lost since referendum day", "A long-run forecast relative to a hypothetical path with continued membership", "The annual cost of customs declarations as a share of GDP", "A forecast of the permanent increase in consumer prices" ],
    correct_option: 1,
    explanation: "It is a modelled long-run difference from a hypothetical path in which the UK remained, not a direct reading from current GDP.",
    source_name: "Office for Budget Responsibility",
    source_url: "https://obr.uk/forecasts-in-depth/the-economy-forecast/brexit-analysis/",
    evidence_direction: -1
  },
  {
    prompt: "Why does the House of Commons Library caution against attributing every post-2020 trade change to Brexit?",
    options: [ "The UK stopped collecting trade statistics in 2020", "The TCA did not affect goods trade until 2024", "The pandemic, war in Ukraine and supply-chain disruption overlapped", "Only the European Commission publishes UK trade data" ],
    correct_option: 2,
    explanation: "Official analysis cautions that several major shocks overlapped, complicating causal comparisons.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7851/",
    evidence_direction: -1
  },
  {
    prompt: "What immigration-system change took effect when the Brexit transition period ended?",
    options: [ "EU free movement continued only for workers", "All short-term EU visits required work visas", "The UK adopted the EU Blue Card system", "EU free movement ended and a UK points-based system began" ],
    correct_option: 3,
    explanation: "EU free movement ended on 31 December 2020; most new EU arrivals became subject to UK immigration rules.",
    source_name: "UK Government",
    source_url: "https://www.gov.uk/guidance/the-uks-points-based-immigration-system-information-for-eu-citizens",
    evidence_direction: -1
  },
  {
    prompt: "Which entitlement generally accompanies citizenship of an EU Member State?",
    options: [ "The right to live, work and study in other EU countries under free-movement rules", "Automatic voting rights in every national election in Europe", "Exemption from income tax while working in another member state", "Automatic eligibility for every country's welfare benefits without conditions" ],
    correct_option: 0,
    explanation: "EU citizenship includes free-movement rights to live, work and study across member states, subject to treaty conditions.",
    source_name: "European Commission",
    source_url: "https://ec.europa.eu/justice/citizenship/index_en.html",
    evidence_direction: 1
  },
  {
    prompt: "How did Brexit affect the ability of Irish citizens to live and work in the United Kingdom?",
    options: [ "They became subject to the points-based system", "Their Common Travel Area rights continued", "Their rights continued only in Northern Ireland", "They had to obtain settled status under the EU Settlement Scheme" ],
    correct_option: 1,
    explanation: "Irish citizens remain protected by the Common Travel Area and generally do not need permission to live and work in the UK.",
    source_name: "UK Government",
    source_url: "https://www.gov.uk/government/publications/uk-points-based-immigration-system-further-details-statement/uk-points-based-immigration-system-further-details-statement",
    evidence_direction: -1
  },
  {
    prompt: "By the end of 2025, approximately how many people had received UK immigration status through the EU Settlement Scheme?",
    options: [ "3.2 million", "7.4 million", "More than 5.8 million", "1.9 million" ],
    correct_option: 2,
    explanation: "The Home Office reported status for more than 5.8 million EU, EEA and Swiss citizens and eligible family members.",
    source_name: "UK Government",
    source_url: "https://www.gov.uk/government/publications/eu-settlement-scheme-euss-status-automation-update-april-2026/eu-settlement-scheme-euss-status-automation-update",
    evidence_direction: 0
  },
  {
    prompt: "Before leaving, what was the UK's overall position in the EU budget after direct public-sector receipts?",
    options: [ "Its payments and receipts were approximately equal", "It alternated annually between contributor and recipient", "It was a net recipient", "It was a net contributor" ],
    correct_option: 3,
    explanation: "The UK was a net contributor, although estimates vary depending on which direct EU payments to UK organisations are counted.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7886/",
    evidence_direction: -1
  },
  {
    prompt: "After including EU funding paid directly to UK organisations, what was the UK's average annual net contribution in 2016–2019?",
    options: [ "Approximately £7–7.5 billion", "Approximately £12–13 billion", "Approximately £3–3.5 billion", "Approximately £18 billion" ],
    correct_option: 0,
    explanation: "The Commons Library estimates roughly £7–7.5 billion annually using this broader treatment of receipts.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7886/",
    evidence_direction: -1
  },
  {
    prompt: "What does a country's net contribution to the EU budget measure?",
    options: [ "The total economic return from single-market membership", "Direct budget payments minus specified receipts", "The effect of EU regulation on business costs", "Changes in tax revenue caused by migration" ],
    correct_option: 1,
    explanation: "It measures direct budget flows, not wider effects such as trade, investment, regulation or migration.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7886/",
    evidence_direction: 1
  },
  {
    prompt: "Why does the UK still make some payments connected with EU institutions after leaving?",
    options: [ "Former members pay the standard membership fee for ten years", "The TCA requires the UK to fund the Common Agricultural Policy", "The withdrawal settlement and participation in selected programmes involve payments", "The UK remains legally part of the EU budget until 2030" ],
    correct_option: 2,
    explanation: "The UK continues to meet pre-existing commitments through the withdrawal settlement and pays to join selected programmes.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-7886/",
    evidence_direction: 0
  },
  {
    prompt: "What trade-policy power did the UK regain upon leaving the EU's common commercial policy?",
    options: [ "The power to set tariffs on goods entering EU countries", "The power to withdraw from World Trade Organization rules", "The power to prohibit EU countries from negotiating collectively", "The power to negotiate its own trade agreements" ],
    correct_option: 3,
    explanation: "The UK now negotiates its own trade agreements, including agreements with Japan, Australia and New Zealand.",
    source_name: "UK Government",
    source_url: "https://www.gov.uk/guidance/uk-trade-agreements-in-effect",
    evidence_direction: -1
  },
  {
    prompt: "What long-run increase in UK GDP did the Government's impact assessment estimate for the Australia free-trade agreement?",
    options: [ "Approximately 0.08%", "Approximately 0.8%", "Approximately 1.6%", "Approximately 0.3%" ],
    correct_option: 0,
    explanation: "The Government's impact assessment estimated UK GDP would be about 0.08% higher in the long run than without the agreement.",
    source_name: "UK Government Impact Assessment",
    source_url: "https://www.gov.uk/government/publications/uk-australia-fta-impact-assessment",
    evidence_direction: 1
  },
  {
    prompt: "Following Brexit, where does final authority to make most law applying within the UK principally sit?",
    options: [ "The European Commission and Council", "The UK Parliament and devolved legislatures within their competences", "The Court of Justice of the European Union", "The secretariat of the European Free Trade Association" ],
    correct_option: 1,
    explanation: "EU law no longer has general supremacy in the UK, although treaty obligations and retained or assimilated law still shape domestic rules.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-8375/",
    evidence_direction: -1
  },
  {
    prompt: "What can happen if either the UK or EU breaches obligations in the Trade and Cooperation Agreement?",
    options: [ "The agreement automatically converts into EU membership", "Only a non-binding diplomatic note is available", "Treaty dispute, remedy or rebalancing mechanisms may apply", "The World Bank assumes administration of the disputed policy" ],
    correct_option: 2,
    explanation: "Like other international agreements, the TCA creates reciprocal obligations backed by governance and dispute mechanisms.",
    source_name: "UK–EU Trade and Cooperation Agreement",
    source_url: "https://www.gov.uk/government/publications/ukeu-and-eaec-trade-and-cooperation-agreement-ts-no82021",
    evidence_direction: 1
  },
  {
    prompt: "What happened to the UK's membership of the European Convention on Human Rights when it left the EU?",
    options: [ "It ended with the Brexit transition period", "It continued only for Northern Ireland", "It was replaced by the EU Charter of Fundamental Rights", "It continued because the Convention belongs to the separate Council of Europe" ],
    correct_option: 3,
    explanation: "The ECHR belongs to the separate Council of Europe, not the EU; Brexit did not end UK membership.",
    source_name: "House of Commons Library",
    source_url: "https://commonslibrary.parliament.uk/research-briefings/cbp-9958/",
    evidence_direction: 0
  },
  {
    prompt: "What is the UK's current relationship with the EU's Horizon Europe research programme?",
    options: [ "The UK participates as an associated country", "UK researchers may participate only through Irish institutions", "The UK is excluded from all programme funding", "The UK participates as a full EU Member State" ],
    correct_option: 0,
    explanation: "The UK became an associated country to Horizon Europe, allowing eligible UK researchers to participate under agreed financial terms.",
    source_name: "European Commission",
    source_url: "https://research-and-innovation.ec.europa.eu/strategy/strategy-research-and-innovation/europe-world/international-cooperation/association-horizon-europe/united-kingdom_en",
    evidence_direction: -1
  },
  {
    prompt: "Why do some movements of goods from Great Britain to Northern Ireland follow special post-Brexit arrangements?",
    options: [ "Northern Ireland is an EU Member State for goods policy", "The arrangements protect both the open Irish land border and the EU single market", "Great Britain and Northern Ireland use separate currencies", "Northern Ireland is outside the UK customs territory" ],
    correct_option: 1,
    explanation: "The Windsor Framework creates differentiated arrangements because Northern Ireland shares a land border with the EU.",
    source_name: "UK Government Windsor Framework",
    source_url: "https://www.gov.uk/government/publications/the-windsor-framework",
    evidence_direction: 1
  }
].freeze
