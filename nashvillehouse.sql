Create Database NashvilleHousingProject

use NashvilleHousingProject

select TOP (1000) * from dbo.NashvilleHousing

--Data Cleaning Using SQL
select * from dbo.NashvilleHousing

-- Standardize Sales date by removing the time

Select SalesDate,CAST(SaleDate as date) AS SaleDate
from dbo.NashvilleHousing

update NashvilleHousing
SET SaleDate = CAST(SaleDate as date) 

Alter Table NashvilleHousing
add SalesDate date

Update NashvilleHousing
SET SalesDate = CAST(SaleDate as date) 

--Populate Property Address Data

Select *
from dbo.NashvilleHousing
where PropertyAddress is NULL
ORDER BY ParcelID

Select A.ParcelID,A.PropertyAddress,B.ParcelID,B.PropertyAddress,ISNULL(A.PropertyAddress,B.PropertyAddress)
from dbo.NashvilleHousing A
JOIN dbo.NashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ]<>B.[UniqueID ]
where A.PropertyAddress is null

Update A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
from dbo.NashvilleHousing A
JOIN dbo.NashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ]<>B.[UniqueID ]
where A.PropertyAddress is null

-- Break Address down in to Individual Columns ( Address , City , State )

Select PropertyAddress
from dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From dbo.NashvilleHousing


Select OwnerAddress
From dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From dbo.NashvilleHousing

-- Change Y and N to Yes or No in Sold and Vacant field

select distinct Soldasvacant from dbo.NashvilleHousing

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Remove Duplicates In Line 159 Replace Select with DELETE to remove Duplicates then use Select to double check if duplicates was removed

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



Select *
From dbo.NashvilleHousing

-- Delete Irrelevant Columns

Select *
From dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
