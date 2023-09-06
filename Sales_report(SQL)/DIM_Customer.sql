--Cleansed DIM_Customer Table --
SELECT 
  c.customerKey AS CustomerKey, 
  --[GeographyKey],
  --[CustomerAlternateKey],
  --[Title],
  c.firstName AS [first Name], 
  --[MiddleName],
  c.lastname AS [LastName], 
  c.firstname + ' ' + lastname AS [Full Name], 
  --Combined First and Last Name
  --[NameStyle],
  --[BirthDate],
  --[MaritalStatus],
  --[Suffix],
  CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender, 
  --[EmailAddress],
  --[YearlyIncome],
  --[TotalChildren],
  --[NumberChildrenAtHome],
  --[EnglishEducation],
  --[SpanishEducation],
  --[FrenchEducation],
  --[EnglishOccupation],
  --[SpanishOccupation],
  --[FrenchOccupation],
  --[HouseOwnerFlag],
  --[NumberCarsOwned],
  --[AddressLine1],
  --[AddressLine2],
  --[Phone],
  c.DateFirstPurchase AS DateFirstPurchase, 
  --[CommuteDistance]
  g.city AS [Customer City] -- Joined in customer City frim Geography Table
FROM 
  dbo.DimCustomer AS c 
  LEFT JOIN dbo.DimGeography AS g ON g.GeographyKey = c.GeographyKey 
ORDER BY 
  CustomerKey ASC --Ordered List by CustomerKey (Ascending order)
