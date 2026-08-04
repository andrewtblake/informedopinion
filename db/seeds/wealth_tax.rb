WEALTH_TAX_FACTS = [
  {
    prompt: "What does “net wealth” mean in the context of a wealth tax?",
    options: [ "The value of assets minus eligible debts", "Annual income after Income Tax", "The value of assets before any debts", "Cash savings plus annual earnings" ],
    correct_option: 0,
    explanation: "A net wealth tax applies to the value of a person's assets after subtracting eligible liabilities.",
    source_name: "OECD",
    source_url: "https://www.oecd.org/en/publications/the-role-and-design-of-net-wealth-taxes-in-the-oecd_9789264290303-en.html",
    evidence_direction: 0
  },
  {
    prompt: "Does the United Kingdom currently levy a comprehensive annual tax on individuals' total net wealth?",
    options: [ "Yes, through Council Tax", "No, although it taxes some assets, transfers and gains", "Yes, through Inheritance Tax", "Only on people with wealth above £10 million" ],
    correct_option: 1,
    explanation: "The UK taxes transactions, returns, transfers and some forms of property, but has no comprehensive tax on ownership of total net wealth.",
    source_name: "Wealth Tax Commission",
    source_url: "https://www.ukwealth.tax/wealth-in-the-uk",
    evidence_direction: 1
  },
  {
    prompt: "What distinguishes an annual wealth tax from a one-off wealth tax?",
    options: [ "An annual tax covers property while a one-off tax covers shares", "A one-off tax is always paid immediately", "An annual tax is assessed repeatedly; a one-off tax is assessed once", "Only an annual tax can deduct debts" ],
    correct_option: 2,
    explanation: "An annual wealth tax creates a recurring assessment, while a one-off tax fixes a single charge by reference to one valuation date.",
    source_name: "Wealth Tax Commission",
    source_url: "https://www.ukwealth.tax/s/A-Wealth-Tax-For-The-UK.pdf",
    evidence_direction: -1
  },
  {
    prompt: "Under the proposed 1% tax above £10 million, what annual bill would arise on net wealth of exactly £12 million?",
    options: [ "£120,000", "£100,000", "£12,000", "£20,000" ],
    correct_option: 3,
    explanation: "Only the £2 million above the threshold is taxed; 1% of £2 million is £20,000.",
    source_name: "OECD: wealth-tax rate design",
    source_url: "https://www.oecd.org/en/publications/the-role-and-design-of-net-wealth-taxes-in-the-oecd_9789264290303-en/full-report/component-7.html",
    evidence_direction: 0
  },
  {
    prompt: "Why does deducting debt matter when measuring net wealth?",
    options: [ "Two people with equal assets can have very different wealth after liabilities", "It converts the tax into an income tax", "It makes every mortgaged property exempt", "It prevents assets from needing valuation" ],
    correct_option: 0,
    explanation: "Gross assets alone do not show the owner's economic position: associated liabilities reduce the owner's net claim.",
    source_name: "OECD",
    source_url: "https://www.oecd.org/en/publications/the-role-and-design-of-net-wealth-taxes-in-the-oecd_9789264290303-en/full-report/component-7.html",
    evidence_direction: 0
  },
  {
    prompt: "Under an individual £10 million threshold, how would a married couple's liability be determined?",
    options: [ "Their wealth would always be combined under one threshold", "Each individual would be assessed against a separate £10 million threshold", "Only the higher-wealth spouse would file", "Marriage would automatically double the tax rate" ],
    correct_option: 1,
    explanation: "An individual tax unit gives each person a separate threshold; ownership between people therefore matters.",
    source_name: "Wealth Tax Commission",
    source_url: "https://www.ukwealth.tax/s/A-Wealth-Tax-For-The-UK.pdf",
    evidence_direction: 0
  },
  {
    prompt: "Under a 1% tax above £10 million, is the first £10 million itself taxed?",
    options: [ "Yes, at 0.5%", "Yes, at 1% once the threshold is crossed", "No; only wealth above £10 million is taxed", "No, unless it includes property" ],
    correct_option: 2,
    explanation: "An exemption threshold removes the first £10 million from the tax base rather than creating a cliff edge.",
    source_name: "OECD: wealth-tax rate design",
    source_url: "https://www.oecd.org/en/publications/the-role-and-design-of-net-wealth-taxes-in-the-oecd_9789264290303-en/full-report/component-7.html",
    evidence_direction: 0
  },
  {
    prompt: "If an individual's taxable wealth stayed unchanged, why would a comprehensive annual net wealth tax create another liability the following year?",
    options: [ "Selling an asset", "Receiving a dividend", "Dying or making a gift", "The arrival of each new annual assessment" ],
    correct_option: 3,
    explanation: "The proposed tax is on the stock of wealth each year, not only on a disposal, return or transfer.",
    source_name: "OECD",
    source_url: "https://www.oecd.org/en/publications/the-role-and-design-of-net-wealth-taxes-in-the-oecd_9789264290303-en.html",
    evidence_direction: -1
  },
  {
    prompt: "What was median household wealth in Great Britain in April 2020 to March 2022?",
    options: [ "£293,700", "£96,400", "£518,200", "£1,200,500" ],
    correct_option: 0,
    explanation: "ONS estimated median household wealth at £293,700 for this period.",
    source_name: "Office for National Statistics",
    source_url: "https://www.ons.gov.uk/peoplepopulationandcommunity/personalandhouseholdfinances/incomeandwealth/bulletins/totalwealthingreatbritain/april2020tomarch2022",
    evidence_direction: 1
  },
  {
    prompt: "At approximately what wealth level did a household enter Great Britain's wealthiest 10% in 2020–2022?",
    options: [ "£500,000", "£1,200,500", "£3,121,500", "£10 million" ],
    correct_option: 1,
    explanation: "ONS estimated that the wealthiest household decile began at £1,200,500.",
    source_name: "Office for National Statistics",
    source_url: "https://www.ons.gov.uk/peoplepopulationandcommunity/personalandhouseholdfinances/incomeandwealth/bulletins/totalwealthingreatbritain/april2020tomarch2022",
    evidence_direction: 1
  },
  {
    prompt: "At approximately what wealth level did a household enter Great Britain's wealthiest 1% in 2020–2022?",
    options: [ "£1,200,500", "£10 million", "£3,121,500", "£293,700" ],
    correct_option: 2,
    explanation: "ONS estimated that the wealthiest 1% of households had total wealth of at least £3,121,500.",
    source_name: "Office for National Statistics",
    source_url: "https://www.ons.gov.uk/peoplepopulationandcommunity/personalandhouseholdfinances/incomeandwealth/bulletins/totalwealthingreatbritain/april2020tomarch2022",
    evidence_direction: 1
  },
  {
    prompt: "How did the wealth share of Great Britain's wealthiest 1% compare with that of the least wealthy 50% in 2020–2022?",
    options: [ "The bottom 50% held five times as much", "The top 1% held twice as much", "The top 1% held ten times as much", "Each group held about 10% of total household wealth" ],
    correct_option: 3,
    explanation: "ONS estimated that each group held 10% of total household wealth.",
    source_name: "Office for National Statistics",
    source_url: "https://www.ons.gov.uk/peoplepopulationandcommunity/personalandhouseholdfinances/incomeandwealth/bulletins/totalwealthingreatbritain/april2020tomarch2022",
    evidence_direction: 1
  },
  {
    prompt: "Which component made up the largest share of total Great British household wealth in 2020–2022?",
    options: [ "Net property wealth, at about 40%", "Private pension wealth, at about 55%", "Physical possessions, at about 40%", "Net financial wealth, at about 35%" ],
    correct_option: 0,
    explanation: "Net property wealth was the largest component at 40%, narrowly ahead of private pensions.",
    source_name: "Office for National Statistics",
    source_url: "https://www.ons.gov.uk/peoplepopulationandcommunity/personalandhouseholdfinances/incomeandwealth/bulletins/totalwealthingreatbritain/april2020tomarch2022",
    evidence_direction: -1
  },
  {
    prompt: "What share of Great British household wealth consisted of private pension wealth in 2020–2022?",
    options: [ "10%", "35%", "55%", "14%" ],
    correct_option: 1,
    explanation: "ONS estimated private pensions at 35% of household wealth, making their inclusion or exclusion consequential.",
    source_name: "Office for National Statistics",
    source_url: "https://www.ons.gov.uk/peoplepopulationandcommunity/personalandhouseholdfinances/incomeandwealth/bulletins/totalwealthingreatbritain/april2020tomarch2022",
    evidence_direction: -1
  },
  {
    prompt: "What was the Gini coefficient for household wealth in Great Britain in 2020–2022?",
    options: [ "0.36", "0.87", "0.59", "0.10" ],
    correct_option: 2,
    explanation: "The household-wealth Gini coefficient was 0.59, where zero represents complete equality and one complete inequality.",
    source_name: "Office for National Statistics",
    source_url: "https://www.ons.gov.uk/peoplepopulationandcommunity/personalandhouseholdfinances/incomeandwealth/bulletins/totalwealthingreatbritain/april2020tomarch2022",
    evidence_direction: 1
  },
  {
    prompt: "How did Great Britain's household-wealth Gini compare with the disposable-income Gini for financial year 2022?",
    options: [ "Both were 0.59", "Income was more unequal: 0.59 versus 0.36", "They cannot be compared using a Gini coefficient", "Wealth was more unequal: 0.59 versus 0.36" ],
    correct_option: 3,
    explanation: "ONS reported a wealth Gini of 0.59 and a disposable-income Gini of 0.36.",
    source_name: "Office for National Statistics",
    source_url: "https://www.ons.gov.uk/peoplepopulationandcommunity/personalandhouseholdfinances/incomeandwealth/bulletins/totalwealthingreatbritain/april2020tomarch2022",
    evidence_direction: 1
  },
  {
    prompt: "Which component of Great British household wealth was the most unequally distributed in 2020–2022?",
    options: [ "Net financial wealth, with a Gini of 0.87", "Private pension wealth, with a Gini of 0.36", "Physical wealth, with a Gini of 0.87", "Net property wealth, with a Gini of 0.10" ],
    correct_option: 0,
    explanation: "Net financial wealth was the most unequal component, with a Gini coefficient of 0.87.",
    source_name: "Office for National Statistics",
    source_url: "https://www.ons.gov.uk/peoplepopulationandcommunity/personalandhouseholdfinances/incomeandwealth/bulletins/totalwealthingreatbritain/april2020tomarch2022",
    evidence_direction: 1
  },
  {
    prompt: "How many OECD countries levied individual net wealth taxes in 1990, according to the OECD's 2018 review?",
    options: [ "Four", "Twelve", "Twenty-six", "All OECD countries" ],
    correct_option: 1,
    explanation: "The OECD found that 12 countries had such taxes in 1990.",
    source_name: "OECD",
    source_url: "https://www.oecd.org/en/publications/the-role-and-design-of-net-wealth-taxes-in-the-oecd_9789264290303-en.html",
    evidence_direction: -1
  },
  {
    prompt: "How many OECD countries still levied recurrent individual net wealth taxes in 2017?",
    options: [ "Twelve", "None", "Four", "Twenty-six" ],
    correct_option: 2,
    explanation: "Only four OECD countries retained recurrent individual net wealth taxes in 2017.",
    source_name: "OECD",
    source_url: "https://www.oecd.org/en/publications/the-role-and-design-of-net-wealth-taxes-in-the-oecd_9789264290303-en.html",
    evidence_direction: -1
  },
  {
    prompt: "What range did top statutory net wealth-tax rates generally occupy in countries reviewed by the OECD?",
    options: [ "5% to 15%", "Exactly 1% everywhere", "Less than 0.1% in every case", "Roughly 0.5% to 2.5%" ],
    correct_option: 3,
    explanation: "The OECD found that top rates generally ranged from 0.5% to 2.5%, depending on country and period.",
    source_name: "OECD",
    source_url: "https://www.oecd.org/en/publications/the-role-and-design-of-net-wealth-taxes-in-the-oecd_9789264290303-en/full-report/component-7.html",
    evidence_direction: 0
  },
  {
    prompt: "What commonly happens to a wealth tax's base when many asset exemptions and reliefs are added?",
    options: [ "The base narrows and avoidance opportunities can increase", "Valuation becomes unnecessary", "Revenue becomes independent of taxpayer behaviour", "Every taxpayer's liability rises" ],
    correct_option: 0,
    explanation: "Exemptions shrink the taxable base and can encourage people to rearrange holdings toward favoured assets.",
    source_name: "OECD",
    source_url: "https://www.oecd.org/en/publications/the-role-and-design-of-net-wealth-taxes-in-the-oecd_9789264290303-en/full-report/component-7.html",
    evidence_direction: -1
  },
  {
    prompt: "Which valuation basis does the OECD recommend for assets included in a net wealth tax?",
    options: [ "Original purchase price", "Market value", "Insured value only", "A fixed value that never changes" ],
    correct_option: 1,
    explanation: "The OECD recommends aligning the tax base with asset market values, while recognising practical reassessment issues.",
    source_name: "OECD",
    source_url: "https://www.oecd.org/en/publications/the-role-and-design-of-net-wealth-taxes-in-the-oecd_9789264290303-en/full-report/component-7.html",
    evidence_direction: -1
  },
  {
    prompt: "What payment mechanism does the OECD suggest for taxpayers who are wealthy in assets but short of cash?",
    options: [ "Automatic permanent exemption", "Compulsory sale of the largest asset", "Payment by instalments", "Conversion of the liability into Income Tax" ],
    correct_option: 2,
    explanation: "Instalment arrangements are one recommended way to address genuine liquidity constraints.",
    source_name: "OECD",
    source_url: "https://www.oecd.org/en/publications/the-role-and-design-of-net-wealth-taxes-in-the-oecd_9789264290303-en/full-report/component-7.html",
    evidence_direction: 1
  },
  {
    prompt: "Why do business-asset exemptions require tightly defined eligibility rules?",
    options: [ "Listed shares cannot be valued", "Businesses never generate cash", "International law requires every business to be exempt", "Broad exemptions can invite reclassification of personal wealth as business wealth" ],
    correct_option: 3,
    explanation: "The OECD recommends clear, restrictive criteria so business relief does not become a route for sheltering unrelated assets.",
    source_name: "OECD",
    source_url: "https://www.oecd.org/en/publications/the-role-and-design-of-net-wealth-taxes-in-the-oecd_9789264290303-en/full-report/component-7.html",
    evidence_direction: -1
  },
  {
    prompt: "What does “asset-rich but cash-poor” mean for payment of a wealth tax?",
    options: [ "A person has high-value assets but insufficient liquid resources or income to pay readily", "A person owns only cash and no investments", "A person's debts exceed all assets", "A person has high income but no taxable assets" ],
    correct_option: 0,
    explanation: "A tax on a stock of wealth can create a payment problem where wealth is held in illiquid property, farms, businesses or pensions.",
    source_name: "Wealth Tax Commission evidence paper",
    source_url: "https://researchonline.lse.ac.uk/113308/",
    evidence_direction: -1
  },
  {
    prompt: "Which included asset does the Institute for Fiscal Studies identify as especially difficult to value annually?",
    options: [ "Cash in a bank account", "A privately owned business", "Publicly traded shares", "Government bonds" ],
    correct_option: 1,
    explanation: "Private businesses lack a continuously observable market price and may require costly, contestable valuations.",
    source_name: "Institute for Fiscal Studies",
    source_url: "https://ifs.org.uk/articles/wealth-tax-would-be-poor-substitute-properly-taxing-sources-and-uses-wealth",
    evidence_direction: -1
  },
  {
    prompt: "What incentive concern does the Institute for Fiscal Studies raise about taxing the same wealth every year?",
    options: [ "It guarantees higher investment returns", "It taxes spending rather than wealth", "It can penalise saving and investment", "It eliminates tax differences between assets" ],
    correct_option: 2,
    explanation: "An annual charge reduces the after-tax return to accumulating and retaining taxable assets.",
    source_name: "Institute for Fiscal Studies",
    source_url: "https://ifs.org.uk/articles/wealth-tax-would-be-poor-substitute-properly-taxing-sources-and-uses-wealth",
    evidence_direction: -1
  },
  {
    prompt: "Which administrative measure does the OECD recommend to improve enforcement of a net wealth tax?",
    options: [ "Relying exclusively on voluntary estimates", "Ending exchange of offshore-account information", "Keeping asset ownership secret from the tax authority", "Developing third-party reporting and international information exchange" ],
    correct_option: 3,
    explanation: "Information supplied by financial institutions and other jurisdictions can help tax authorities verify self-reported wealth.",
    source_name: "OECD",
    source_url: "https://www.oecd.org/en/publications/the-role-and-design-of-net-wealth-taxes-in-the-oecd_9789264290303-en/full-report/component-7.html",
    evidence_direction: 1
  },
  {
    prompt: "What event ordinarily triggers UK Capital Gains Tax on a chargeable asset?",
    options: [ "A disposal producing a chargeable gain", "Owning the asset at the end of every year", "The asset owner's annual birthday", "Any increase in estimated value, even without disposal" ],
    correct_option: 0,
    explanation: "Capital Gains Tax ordinarily taxes gains when a chargeable asset is disposed of, unlike an annual tax on ownership.",
    source_name: "HM Revenue & Customs",
    source_url: "https://www.gov.uk/capital-gains-tax",
    evidence_direction: 1
  },
  {
    prompt: "How much Inheritance Tax revenue did HMRC report for the year ending 31 March 2025?",
    options: [ "£13.8 billion", "£8.2 billion", "£43.0 billion", "£1.1 billion" ],
    correct_option: 1,
    explanation: "HMRC's 2024–25 accounts reported £8.2 billion of Inheritance Tax revenue.",
    source_name: "HM Revenue & Customs annual report",
    source_url: "https://www.gov.uk/government/publications/hmrc-annual-report-and-accounts-2024-to-2025/hmrcs-annual-report-and-accounts-2024-to-2025-our-accounts-and-annexes",
    evidence_direction: 0
  }
].freeze
