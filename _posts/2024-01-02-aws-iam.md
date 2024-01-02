---
layout: post
title: "AWS IAM"
date: 2023-09-20 03:42:00 -0400
modified_date: 2023-09-20 03:42:00 -0400
categories: aws IAM
---

# AWS IAM

## Purpose

## Characteristics

## Useful AWS commands

```
aws iam list-attached-user-policies --user-name jhon.smith
aws iam list-groups-for-user
aws iam list-user-policies
```

```sh
function _getUserIamPermissions() {
    export AWS_PAGER="";
    local _user="${1}";

    local outputManagedPolicies="";
    local outputUserPolicies="";
    local outputManagedGroupPolicies="";
    local outputGroupPolicies="";

    # Managed Policies Attached to the IAM User
    local _managedpolicies=$(aws iam list-attached-user-policies --user-name "${_user}" | jq -r '.AttachedPolicies[].PolicyArn';);
    for policy in ${_managedpolicies}; do
        local versionId=$(aws iam get-policy --policy-arn "${policy}" | jq -r '.Policy.DefaultVersionId';);
        outputManagedPolicies=$(aws iam get-policy-version --policy-arn "${policy}" --version-id "${versionId}";);
        printf "%s" "${outputManagedPolicies}";
    done;

    # Inline Policies on the IAM User
    local _userpolicies=$(aws iam list-user-policies --user-name "${_user}" | jq -r '.PolicyNames[]';);
    for policy in ${_userpolicies}; do
        outputUserPolicies=$(aws iam get-user-policy --user-name "${_user}" --policy-name "${policy}";);
        printf "%s" "${outputUserPolicies}";
    done;

    # Get all of the IAM User's assigned IAM Groups
    local _groups=$(aws iam list-groups-for-user --user-name "${_user}" | jq -r '.Groups[].GroupName';);
    for group in ${_groups}; do
        # Managed Policies Attached to the IAM Group
        local _managedgrouppolicies=$(aws iam list-attached-group-policies --group-name "${group}" | jq -r '.AttachedPolicies[].PolicyArn';);
        for policy in ${_managedgrouppolicies}; do
            local versionId=$(aws iam get-policy --policy-arn "${policy}" | jq -r '.Policy.DefaultVersionId';);
            outputManagedGroupPolicies=$(aws iam get-policy-version --policy-arn "${policy}" --version-id "${versionId}" | jq --arg arn "${policy}" '{"PolicyArn": $arn, "Policy": .}';);
            printf "%s" "${outputManagedGroupPolicies}";
        done;

        # Inline Policies on the IAM Group
        local _grouppolicies=$(aws iam list-group-policies --group-name "${group}" | jq -r '.PolicyNames[]';);
        for policy in ${_grouppolicies}; do
            outputGroupPolicies=$(aws iam get-group-policy --group-name "${group}" --policy-name "${policy}";);
            printf "%s" "${outputGroupPolicies}";
        done;
    done;
}

function getUserIamPermissions() {
    local username="${1}";
    _getUserIamPermissions "${username}" | jq -s;
}

```

```sh
$ getUserIamPermissions username
```

## Useful custom policies

### Billing and Cost Management screen readonly access

`AWSBillingReadOnlyAccess` and `AWSBillingConductorReadOnlyAccess`policies are not good enough to share the `Billing and Cost Management` page readonly access to as it has infromation from other features like Budget, Cost Explorer, Report, Optimization hub etc (ex: ce:GetCostAndUsage, ce:GetTags, ce:GetAnomalies, cur:DescribeReportDefinitions).

It is recommeded to carefully craft access to allow only readonly access using policy editor and maintain the policy as code so we can review the changes.

Example

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CostManagementReadOnly",
      "Effect": "Allow",
      "Action": [
        "budgets:ViewBudget",
        "cost-optimization-hub:GetRecommendation",
        "budgets:DescribeBudgetActionsForBudget",
        "ce:GetCostAndUsage",
        "budgets:DescribeBudgetActionHistories",
        "ce:GetReservationPurchaseRecommendation",
        "cost-optimization-hub:GetPreferences",
        "ce:GetPreferences",
        "ce:ListSavingsPlansPurchaseRecommendationGeneration",
        "ce:ListTagsForResource",
        "cur:ListTagsForResource",
        "ce:GetReservationUtilization",
        "ce:GetCostCategories",
        "ce:GetSavingsPlansPurchaseRecommendation",
        "ce:GetSavingsPlansUtilizationDetails",
        "ce:GetDimensionValues",
        "ce:GetAnomalySubscriptions",
        "ce:DescribeReport",
        "ce:GetReservationCoverage",
        "cost-optimization-hub:ListEnrollmentStatuses",
        "ce:GetAnomalyMonitors",
        "ce:GetUsageForecast",
        "ce:DescribeNotificationSubscription",
        "ce:DescribeCostCategoryDefinition",
        "ce:GetRightsizingRecommendation",
        "cur:GetClassicReportPreferences",
        "cost-optimization-hub:ListRecommendations",
        "budgets:DescribeBudgetAction",
        "ce:GetSavingsPlansUtilization",
        "cur:GetClassicReport",
        "ce:GetAnomalies",
        "ce:ListCostCategoryDefinitions",
        "cost-optimization-hub:ListRecommendationSummaries",
        "ce:GetCostForecast",
        "ce:GetApproximateUsageRecords",
        "ce:GetCostAndUsageWithResources",
        "ce:ListCostAllocationTags",
        "budgets:DescribeBudgetActionsForAccount",
        "ce:GetSavingsPlanPurchaseRecommendationDetails",
        "cur:ValidateReportDestination",
        "ce:GetSavingsPlansCoverage",
        "ce:GetConsoleActionSetEnforced",
        "ce:GetTags",
        "cur:GetUsageReport",
        "cur:DescribeReportDefinitions"
      ],
      "Resource": "*"
    }
  ]
}
```

## Resources

- [IAM Policy Simulator](https://policysim.aws.amazon.com/home/index.jsp?#)
- [Cost Management ReadOnly policy](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-example-policies.html#example-policy-ce-api)
