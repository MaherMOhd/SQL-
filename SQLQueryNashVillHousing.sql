--Nashvile housing Data Cleaning with SQL
/*

----------------------------------------------------------------------------*/

select *
from NashvilHousing

--standarize sale date
select saleDateconverted, convert(date, SaleDate)
from NashvilHousing

update NashvilHousing
set SaleDate = convert(date,SaleDate)
where SaleDate = saledate 

alter table Nashvilhousing
add saledateconverted date;

update NashvilHousing
set saleDateconverted = convert(date, saledate)


--populate property address data 
 
 select *
 from nashvilhousing 
 --where PropertyAddress is null
 order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilHousing a
join NashvilHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is not null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilHousing a
join NashvilHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null 


---------------------------------------------------------------------------
--breaking out address into a induvidual columns where address, city, and state are seperated

select PropertyAddress
from NashvilHousing


--getting rid of the commas,
select 
substring(propertyaddress, 1, charindex(',', propertyaddress)-1 ) as Address
, substring(propertyaddress, charindex(',', propertyaddress)+1 , len(Propertyaddress)) as Address
from NashvilHousing 

--adding new columns to split the address
ALTER TABLE nashvilhousing 
add propertySplitaddress nvarchar(255);

update nashvilhousing 
set propertySplitaddress = SUBSTRING(propertyAddress, 1, charindex(',', PropertyAddress) -1) 

alter table nashvilhousing 
add propertysplitcity nvarchar(255);

update NashvilHousing
set  propertysplitcity = substring(propertyaddress, charindex(',', PropertyAddress) +1, len(propertyaddress))

select * 
from NashvilHousing

select OwnerAddress
from NashvilHousing

select 
parsename(replace(OwnerAddress, ',','.'), 1),
parsename(replace(owneraddress, ',','.') , 2),
PARSENAME(replace(owneraddress, ',','.'), 3)
from nashvilhousing 
where OwnerAddress is not null

--seperating the state, city, address

alter table nashvilhousing 
add OwnerseperateAddress nvarchar(255);

update NashvilHousing
set ownerSeperateAddress = parsename(replace(OwnerAddress, ',','.'), 1)

alter table nashvilhousing 
add ownersplitcity nvarchar(255);

update NashvilHousing
set ownersplitcity = parsename(replace(owneraddress,',','.'), 2)

alter table nashvilhousing 
add ownersplitstate nvarchar(255);

update NashvilHousing
set ownersplitstate = parsename(replace(owneraddress, ',','.'), 3)


select *
from NashvilHousing
where OwnerAddress is not null 


---Change Y and N to yes and no in "sold as vacant' column
---------------------------------------------------------------------

select distinct(SoldasVacant),count(soldasvacant)
from NashvilHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant ='y' then 'yes'
		WHEN SoldAsVacant = 'n' then 'no'
		else SoldAsVacant
		end
from nashvilHousing

update NashvilHousing
set soldasvacant = case when SoldAsVacant = 'y' then 'yes'
						when SoldAsVacant = 'n' then 'no'
						else SoldAsVacant
						end
from NashvilHousing



----------------------------------------------------------------------
--removing duplicate 
WITH RowNumCTE AS(
select *,
	ROW_NUMBER() over (
	partition by parcelID,
				propertyAddress,
				saleprice,
				saledate,
				LegalReference
				order by 
					uniqueID 
					) row_num

from NashvilHousing
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
order by propertyAddress


-------------------------------------------------------------------------

--DELETE UNUSED COLUMNS

SELECT * 
FROM NashvilHousing
order by [UniqueID ] asc


ALTER TABLE nashvilhousing 
DROP COLUMN SaleDate
