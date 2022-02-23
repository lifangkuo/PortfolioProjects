Use PortfolioProject;

Select * From PortfolioProject..NashvilleHousing;


-- Change the datatype of SaleDate into Date


Select SaleDate, Convert(Date, SaleDate)
From PortfolioProject..NashvilleHousing;

Alter Table NashvilleHousing
Add SaleDateConverted Date;


Update NashvilleHousing
Set SaleDateConverted = Convert(Date, SaleDate);


Select SaleDateConverted 
From NashvilleHousing;


-- Populate Property Address Data

Select *
From PortfolioProject..NashvilleHousing
Where PropertyAddress is null
Order by ParcelID;


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID] <> b.[UniqueID]
where a.propertyaddress is null;


Update a 
SET propertyaddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID] <> b.[UniqueID]
where a.propertyaddress is null;


-- Breaking out Property Address into individual columns (Address, City)

Select PropertyAddress
From PortfolioProject..NashvilleHousing;

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress)) as City
From PortfolioProject..NashvilleHousing;


Alter Table NashvilleHousing
Add PropertySplitAddress varchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

Alter Table NashvilleHousing
Add PropertySplitCity varchar(255);


Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress))

Select * From PortfolioProject..NashvilleHousing;


-- Breaking out Owner Address into individual columns (Address, City, State)


Select OwnerAddress From PortfolioProject..NashvilleHousing;

Select 
PARSENAME(Replace(OwnerAddress, ',', '.'),3),
PARSENAME(Replace(OwnerAddress, ',', '.'),2),
PARSENAME(Replace(OwnerAddress, ',', '.'),1)
From PortfolioProject..NashvilleHousing;

Alter Table NashvilleHousing
Add OwnerSplitAddress varchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'),3);

Alter Table NashvilleHousing
Add OwnerSplitCity varchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'),2);

Alter Table NashvilleHousing
Add OwnerSplitState varchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'),1);



-- Change Y and N to Yes and No in 'Sold as Vacnt' field

Select Distinct SoldAsVacant, Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2;


Select SoldAsVacant,
(Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
End) as SoldAsVacantModified
From PortfolioProject..NashvilleHousing;

Update NashvilleHousing
Set SoldAsVacant = (Case When SoldAsVacant = 'Y' Then 'Yes'
						When SoldAsVacant = 'N' Then 'No'
						Else SoldAsVacant
						End)



-- Remove Duplicates


With RowNumCTE As (
Select *,
Row_Number() Over (
Partition By ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
Order by
UniqueID) row_num
From PortfolioProject..NashvilleHousing
)
Delete From RowNumCTE
Where row_num > 1;


With RowNumCTE As (
Select *,
Row_Number() Over (
Partition By ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
Order by
UniqueID) row_num
From PortfolioProject..NashvilleHousing
)
Select * From RowNumCTE Where row_num > 1
Order by PropertyAddress;





-- Delete Unused Columns

Select * From PortfolioProject..NashvilleHousing;

Alter Table PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject..NashvilleHousing
Drop Column SaleDate