

Select * from projects.dbo.NashvilleHousing

/* STANDERDIZING DATE FORMAT */

select SaleDate from PROJECTS.dbo.NashvilleHousing

select SaleDate,convert(Date,SaleDate) as DateConverted  from PROJECTS.dbo.NashvilleHousing

alter table PROJECTS.dbo.NashvilleHousing
add DateConverted date ;
update PROJECTS.dbo.NashvilleHousing
set DateConverted = convert(Date,SaleDate)


/* TREATING COLUMN SOLDASVACANT */

Select SoldAsVacant from PROJECTS.dbo.NashvilleHousing

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PROJECTS.dbo.NashvilleHousing
Group by SoldAsVacant

select SoldAsVacant,
case when SoldasVacant = 'N' then 'No'
when SoldasVacant = 'Y' then 'Yes'
else SoldAsVacant
end
from PROJECTS.dbo.NashvilleHousing

update PROJECTS.dbo.NashvilleHousing
set SoldAsVacant = case when SoldasVacant = 'N' then 'No'
when SoldasVacant = 'Y' then 'Yes'
else SoldAsVacant
end

select * from PROJECTS.dbo.NashvilleHousing


/* NULL VALUES CHECK IN PROP ADD COLUMN */

Select * from PROJECTS.dbo.NashvilleHousing
where PropertyAddress is null 


/* PROPERTY ADDRESS TREATMENT */


Select PropertyAddress from PROJECTS.dbo.NashvilleHousing
where PropertyAddress is null 


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress) 
from PROJECTS.dbo.NashvilleHousing a 
join PROJECTS.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from PROJECTS.dbo.NashvilleHousing a 
join PROJECTS.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]



Select PropertyAddress from PROJECTS.dbo.NashvilleHousing
where PropertyAddress is null 


/* SEPERATING THE PROPERTY ADDRESS ADD, CITY AND STATE WISE I.E. BREAKING THE ADD COLUMN*/

Select PropertyAddress from PROJECTS.dbo.NashvilleHousing

select substring (PropertyAddress, 1,charindex(',', PropertyAddress) -1 ) as Address
substring (PropertyAddress, charindex(',', PropertyAddress) +1 , len(PropertyAddress))  as City

alter table PROJECTS.dbo.NashvilleHousing
add PropertySplitAddress Nvarchar(255) ;
update PROJECTS.dbo.NashvilleHousing
set PropertySplitAddress = substring (PropertyAddress, 1,charindex(',', PropertyAddress) -1 )

alter table PROJECTS.dbo.NashvilleHousing
add PropertySplitCity Nvarchar(255) ;
update PROJECTS.dbo.NashvilleHousing
set PropertySplitCity = substring (PropertyAddress, charindex(',', PropertyAddress) +1 , len(PropertyAddress))

select * from PROJECTS.dbo.NashvilleHousing

/* SEPERATING THE OWNER ADDRESS ADD, CITY AND STATE WISE I.E. BREAKING THE ADD COLUMN*/

Select OwnerAddress from PROJECTS.dbo.NashvilleHousing

select
parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from PROJECTS.dbo.NashvilleHousing 

alter table PROJECTS.dbo.NashvilleHousing
add OwnerSplitAddress Nvarchar(255) ;
update PROJECTS.dbo.NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress,',','.'),3)

alter table PROJECTS.dbo.NashvilleHousing
add OwnerSplitCity Nvarchar(255) ;
update PROJECTS.dbo.NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress,',','.'),2)

alter table PROJECTS.dbo.NashvilleHousing
add OwnerSplitState Nvarchar(255) ;
update PROJECTS.dbo.NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress,',','.'),1)


Select * from PROJECTS.dbo.NashvilleHousing



/* REMOVING DUPLICATES FROM DATA */


with RowNumCTE as (
select *,
	ROW_NUMBER() Over (
	partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference
	order by UniqueID 
	) row_num

from PROJECTS.dbo.NashvilleHousing
)
select * from RowNumCTE
where row_num > 1
Order by UniqueID


with RowNumCTE as (
select *,
	ROW_NUMBER() Over (
	partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference
	order by UniqueID 
	) row_num

from PROJECTS.dbo.NashvilleHousing
)
Delete from RowNumCTE
where row_num > 1


/*  DELETING UNUSED COLUMNS */


Select * from PROJECTS.dbo.NashvilleHousing


Alter table PROJECTS.dbo.NashvilleHousing
drop column PropertyAddress,OwnerAddress,TaxDistrict


Alter table PROJECTS.dbo.NashvilleHousing
drop column SaleDate
