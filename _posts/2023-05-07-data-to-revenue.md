---
layout: post
title: "Data to Value and Governance"
date: 2023-05-07 09:03:00 -0400
modified_date: 2023-05-07 09:03:00 -0400
categories: data
---

# Data

- What is data?

        Anything we share and consume via communication.

## Forms of data

    - Data could be structured or unstructured

## Value

    With the digital transformation, businesses are flooded with data feed from various source. Data has no value until it can be interpreted to generate revenue. Worst than that unused data could cost interms of storage, manitanence and heavily for protecting it.

    Data can produce more value when it is fresh, received from the source of truth (integrity and accuracy) and has structured.

## Privacy

    When the data contains privacy information there are more care needed to be taken care.

## Security

### Data protection

- Data needs to be protected for various reasons
  - Privacy - personal information to meet PII complaince
  - Corruption/Altered - When we let the AI and ML to take decisions, data should be trustworthy.
  - Damage - we learned for decades a simple comma or unexpected charactor halt the system. So it is easy for bad actor to create denial of service if data is not protected.
  - security (ofcourse)

## Governance

- Classify every software with data classification in your application portfolio.
- Define data protection policies
  - data - cost - protection (Example SSN - identity theft - never store)
  - define strong authentication (MFA) and fine grained (zero trust) access.
- Audit sensitive data access.
- Never fall victim of ransomware. Be resiliant to restore from backup and bring the data available almost notime.
- Measure data availability and security level periodically/lively and report.
- Adopt compliance requirement - never take data which is not required. Never share (even application to application) without user (resource owner) consent.

## Classification

- helps to speak with same understanding when organization classifies data in accordance with industry standard terms.
- Few data regulatory policies - HIPAA, PII and GDPR.
- Example - U.S. classification of information system has three classification levels -- Top Secret, Secret, and Confidential
- PII - Personally Identifiable Information - SSN, license number, phone number, address
- PHI - Personal Health Information - health records, insurance, test results, health status and medical appointments
- Financial Information - credit card, bank account infromation, nominee details
- Based on sensitivity - High, Medium, Low.
- Four levels
  1. Public - no restriction - marketing information - content in public website
  1. Internal - available for someone who proved their identity - corporate internal documentation.
  1. Confidential - customer details - business transaction.
  1. Restricted - Any content which is required to be protected by regulatory policies. Anything which could bring down company or affects customer or people reputation/values.

## Data classification roles

It is important to identify individuals and add the data classification duties as part of their job description.

- Data champions - who takes initiatives by challenging others
- Data Owners - who collects and owns the data. It is their job to keep to protect it.
- Data creators - When user input or integration brings data, data creator ask themselves to classify the level and make it clear to the others who handles it.
- Data user - people or system who process data. Need to respect the classification and standards.
- Data custodian - infrastructure provider to store, transfer data who is aligning wiht security advisors.

## References

- https://www.imperva.com/learn/data-security/data-classification/
- https://www.imperva.com/learn/data-security/data-protection
- https://www.spirion.com/data-classification
- https://it.ufl.edu/it-policies/information-security/related-standards-and-documents/data-classification-guidelines/
- https://docs.aws.amazon.com/whitepapers/latest/data-classification/data-classification-models-and-schemes.html
