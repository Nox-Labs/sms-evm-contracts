# RingBufferLib
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/lib/RingBufferLib.sol)

NOTE: There is a difference in meaning between "cardinality" and "count":
- cardinality is the physical size of the ring buffer (i.e. max elements).
- count is the number of elements in the buffer, which may be less than cardinality.


## Functions
### wrap

Returns wrapped TWAB index.

*In order to navigate the TWAB circular buffer, we need to use the modulo operator.*

*For example, if `_index` is equal to 32 and the TWAB circular buffer is of `_cardinality` 32,
it will return 0 and will point to the first element of the array.*


```solidity
function wrap(uint256 _index, uint256 _cardinality) internal pure returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_index`|`uint256`|Index used to navigate through the TWAB circular buffer.|
|`_cardinality`|`uint256`|TWAB buffer cardinality.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|TWAB index.|


### offset

Computes the negative offset from the given index, wrapped by the cardinality.

*We add `_cardinality` to `_index` to be able to offset even if `_amount` is superior to `_cardinality`.*


```solidity
function offset(uint256 _index, uint256 _amount, uint256 _count) internal pure returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_index`|`uint256`|The index from which to offset|
|`_amount`|`uint256`|The number of indices to offset.  This is subtracted from the given index.|
|`_count`|`uint256`|The number of elements in the ring buffer|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|Offsetted index.|


### newestIndex

Returns the index of the last recorded TWAB


```solidity
function newestIndex(uint256 _nextIndex, uint256 _count) internal pure returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_nextIndex`|`uint256`|The next available twab index.  This will be recorded to next.|
|`_count`|`uint256`|The count of the TWAB history.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The index of the last recorded TWAB|


### oldestIndex


```solidity
function oldestIndex(uint256 _nextIndex, uint256 _count, uint256 _cardinality)
    internal
    pure
    returns (uint256);
```

### nextIndex

Computes the ring buffer index that follows the given one, wrapped by cardinality


```solidity
function nextIndex(uint256 _index, uint256 _cardinality) internal pure returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_index`|`uint256`|The index to increment|
|`_cardinality`|`uint256`|The number of elements in the Ring Buffer|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The next index relative to the given index.  Will wrap around to 0 if the next index == cardinality|


### prevIndex

Computes the ring buffer index that preceeds the given one, wrapped by cardinality


```solidity
function prevIndex(uint256 _index, uint256 _cardinality) internal pure returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_index`|`uint256`|The index to increment|
|`_cardinality`|`uint256`|The number of elements in the Ring Buffer|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The prev index relative to the given index.  Will wrap around to the end if the prev index == 0|


