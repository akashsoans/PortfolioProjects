/*
Cleaning Data in SQL Queries
*/

Select *
From Portfolioproject.dbo.NashvilleHousing

---------------------------------------------------------------------------------------------------

--Standardize Date Format

Alter table NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
Set SaleDateConverted = CONVERT(date, SaleDate)


Select SaleDate, SaleDateConverted
From Portfolioproject.dbo.NashvilleHousing

--Populate Property Address Data

Select *
From Portfolioproject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by parcelID

Select a.parcelID,b.parcelId,a.propertyaddress,b.propertyaddress
from Portfolioproject.dbo.NashvilleHousing a
Join Portfolioproject.dbo.NashvilleHousing b 
     on a.parcelID = b.parcelID
	 AND a.UniqueID <> b.UniqueID
where a.propertyaddress is null

Update a
set propertyaddress = isnull(a.propertyaddress, b.propertyaddress)
from Portfolioproject.dbo.NashvilleHousing a
Join Portfolioproject.dbo.NashvilleHousing b 
     on a.parcelID = b.parcelID
	 AND a.UniqueID <> b.UniqueID
where a.propertyaddress is null

-------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)

select 
substring(propertyaddress,1,charindex(',',propertyaddress)-1) as Address,
substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress)) as City
from Portfolioproject.dbo.nashvillehousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255)

Update NashvilleHousing
SET PropertySplitAddress = substring(propertyaddress,1,charindex(',',propertyaddress)-1)

Update NashvilleHousing
SET PropertySplitCity = substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))



Select
Parsename(replace(OwnerAddress,',','.'),3),
Parsename(replace(OwnerAddress,',','.'),2),
Parsename(replace(Owneraddress,',','.'),1)
from portfolioproject.dbo.NashvilleHousing

Alter table NashvilleHousing 
Add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitAddress = Parsename(replace(OwnerAddress,',','.'),3)

Alter table NashvilleHousing 
Add OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitCity = Parsename(replace(OwnerAddress,',','.'),2)

Alter table NashvilleHousing 
Add OwnerSplitState Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitState = Parsename(replace(OwnerAddress,',','.'),1)


-----------------------------------------------------------------------------------


--Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(soldasvacant), Count(soldasvacant)
from Portfolioproject.dbo.NashvilleHousing
group by soldasvacant
order by 2


Select soldasvacant
,case when soldasvacant = 'Y' then 'Yes'
      when soldasvacant = 'N' then 'No'
	  else soldasvacant
	  end
from Portfolioproject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant= case when soldasvacant = 'Y' then 'Yes'
      when soldasvacant = 'N' then 'No'
	  else soldasvacant
	  end


------------------------------------------------------------------------------------------

--Remove Duplicates

with RowNumCTE as(
Select *,
    row_number() over(
	partition by ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by UniqueID
				 ) row_num

from Portfolioproject.dbo.NashvilleHousing

)

--DELETE
--from RowNumCTE
--where row_num>1

Select *
from RowNumCTE
where row_num>1

Select *
from Portfolioproject.dbo.NashvilleHousing


------------------------------------------------------------------

--Delete Unused Columns

alter table portfolioproject.dbo.nashvillehousing
drop column owneraddress, taxdistrict, propertyaddress, saledate

Select*
from Portfolioproject.dbo.NashvilleHousing

