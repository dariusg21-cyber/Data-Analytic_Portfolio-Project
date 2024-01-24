SELECT TOP(1000) [UniqueID ],
ParcelID, LandUse, PropertyAddress,
SaleDate, SalePrice, SoldAsVacant, OwnerAddress, OwnerName,
Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath
FROM projects..NashvilleHousing




/* cleaning data using SQL*/

SELECT * FROM
projects..NashvilleHousing



--standard date format



SELECT SaleDateConverted , CONVERT(DATE, SaleDate)
FROM projects..NashvilleHousing

update NashvilleHousing
SET SaleDate = Convert(Date, SaleDate) 

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

update NashvilleHousing


SET SaleDateConverted = Convert(Date, SaleDate) 




--Populate Property Address date



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL( a.PropertyAddress,b.PropertyAddress)
From projects..NashvilleHousing a
JOIN projects..NashvilleHousing b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL




UPDATE a
SET PropertyAddress = ISNULL( a.PropertyAddress,b.PropertyAddress)
From projects..NashvilleHousing a
JOIN projects..NashvilleHousing b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
  WHERE a.PropertyAddress IS NULL



-- breaking out address into columns (ADDRESS, CITY, STATE)

SELECT propertyAddress
FROM projects..NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM projects..NashvilleHousing



ALTER TABLE NashvilleHousing
ADD PropAddrress NVARCHAR(255);

update NashvilleHousing
SET PropAddrress = SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) -1)



ALTER TABLE NashvilleHousing
ADD PropCity NVARCHAR(255);



update NashvilleHousing
SET PropCity = SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) +1, LEN(PropertyAddress)) 

SELECT * FROM projects..NashvilleHousing


--(Address, city, state)


--SELECT OwnerAddress FROM projects..NashvilleHousing

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM projects..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerAddy NVARCHAR(255);



update NashvilleHousing
SET OwnerAddy = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 



ALTER TABLE NashvilleHousing
ADD OwnerCity NVARCHAR(255);


update NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) 



ALTER TABLE NashvilleHousing
ADD OwnerState NVARCHAR(255);


update NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--SELECT * FROM projects..NashvilleHousing 




--Change y and n to Yes and No in 'Sold as Vacant' field USING CASE STATEMENT


SELECT Distinct(SoldAsVacant), Count(SoldAsVacant) FROM projects..NashvilleHousing
GROUP BY SoldAsVacant
order by 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' Then 'No'
ELSE SoldAsVacant 
   END

FROM projects..NashvilleHousing


UPDATE projects..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' Then 'No'
ELSE SoldAsVacant 
   END







--Remove Duplicates

WITH rowNum
as(

SELECT *, ROW_NUMBER() OVER(PARTITION BY
ParcelId,
PropertyAddress,
SalePrice, 
SaleDate, 
LegalReference 
ORDER BY UniqueId) rowNum
FROM projects..NashvilleHousing
--ORDER BY ParcelID
) 
DELETE from rowNum
WHERE rowNum > 1
--ORDER BY PropertyAddress










--Remove unused colums


SELECT * 
FROM projects..NashvilleHousing


ALTER TABLE projects..NashvilleHousing
DROP COLUMN OwnerAddress, Taxdistrict, PropertyAddress

ALTER TABLE projects..NashvilleHousing
DROP COLUMN SaleDate