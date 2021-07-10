
SELECT * FROM tempdb.dbo.NashvilleHousing

-----------------------------

---Standardize Date Format

SELECT Saledateconverted, CONVERT(Date, SaleDate)
FROM tempdb.dbo.NashvilleHousing

Update  NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

Alter Table tempdb.dbo.NashvilleHousing
Add Saledateconverted Date;

Update  tempdb.dbo.NashvilleHousing
SET Saledateconverted = CONVERT(Date, SaleDate)

----- populate property address data

SELECT *
FROM tempdb.dbo.NashvilleHousing
----where PropertyAddress  is null
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM tempdb.dbo.NashvilleHousing a
JOIN tempdb.dbo.NashvilleHousing b
 on a.ParcelID = b. ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 Update a
 SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
 FROM tempdb.dbo.NashvilleHousing a
JOIN tempdb.dbo.NashvilleHousing b
 on a.ParcelID = b. ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null
  

  -----Breaking out Address into Individul Colums ( Address, City, State)
  SELECT PropertyAddress
FROM tempdb.dbo.NashvilleHousing
----where PropertyAddress  is null
order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX( ',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM tempdb.dbo.NashvilleHousing

Alter Table tempdb.dbo.NashvilleHousing
Add PropertysplitAddress Nvarchar (255);

Update  tempdb.dbo.NashvilleHousing
SET PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX( ',', PropertyAddress)-1)

Alter Table tempdb.dbo.NashvilleHousing
Add PropertysplitCity Nvarchar (255);

Update  tempdb.dbo.NashvilleHousing
SET PropertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT * FROM
tempdb.dbo.NashvilleHousing

--------let's split the date column for OwnerAddress

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM tempdb.dbo.NashvilleHousing

Alter Table tempdb.dbo.NashvilleHousing
Add OwnersplitAddress Nvarchar (255);

Update  tempdb.dbo.NashvilleHousing
SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


Alter Table tempdb.dbo.NashvilleHousing
Add OwnersplitCity Nvarchar (255);

Update  tempdb.dbo.NashvilleHousing
SET OwnersplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


Alter Table tempdb.dbo.NashvilleHousing
Add OwnersplitState Nvarchar (255);

Update  tempdb.dbo.NashvilleHousing
SET OwnersplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT * FROM tempdb.dbo.NashvilleHousing

-------------- Change Y and N to 'Yes' and 'No' in 'Sold as Vacant Field'

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM tempdb.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' then 'No'
     When SoldAsVacant = 'N' then 'Yes'
	 Else SoldAsVacant
	 END
FROM tempdb.dbo.NashvilleHousing


Update tempdb.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' then 'No'
     When SoldAsVacant = 'N' then 'Yes'
	 Else SoldAsVacant
	 END

--------------------- Remove Duplicates

With RowNumCTE AS(
SELECT *,
      ROW_NUMBER() OVER (
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
        ORDER BY 
	  UniqueID) row_num
          From tempdb.dbo.NashvilleHousing
      )
	SELECT * 
	FROM RowNumCTE
	where row_num > 1
    ORDER BY PropertyAddress

-----------------------------------------------

------Delete Unused Columns

SELECT * 
	FROM tempdb.dbo.NashvilleHousing

	ALTER TABLE tempdb.dbo.NashvilleHousing
	DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

	ALTER TABLE tempdb.dbo.NashvilleHousing
	DROP COLUMN SaleDate




