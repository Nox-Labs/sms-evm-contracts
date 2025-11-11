// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "script/lib/SMSDeployer.sol";
import "script/lib/Create3Deployer.sol";

import "src/SMS.sol";
import "src/MMS.sol";
import "src/SMSOmnichainAdapter.sol";
import "src/SMSDataHub.sol";
import "src/extensions/Base.sol";

import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

import "@layerzerolabs/create3-factory/contracts/ICREATE3Factory.sol";

import "test/_utils/LayerZeroDevtoolsHelper.sol";

contract BaseSetup is LayerZeroDevtoolsHelper {
    using SMSDeployer for ICREATE3Factory;
    using Create3Deployer for ICREATE3Factory;

    uint96 public constant MINT_AMOUNT = 1e6;
    uint32 public constant ROUND_BP = 1e4;

    bytes public constant mockData = "mock";

    ICREATE3Factory public create3Factory;

    SMS public sms;
    MMS public mms;
    SMSDataHubMainChain public smsDataHub;
    SMSOmnichainAdapter public adapter;

    ICREATE3Factory public create3Factory2;

    SMS public sms2;
    SMSDataHub public smsDataHub2;
    SMSOmnichainAdapter public adapter2;

    address public user = makeAddr("user");

    uint32 twabPeriodLength = 1 days;

    function setUp() public virtual override {
        super.setUp();

        _beforeSetUp();
        _setUp();
        _afterSetUp();
    }

    function _setUp() internal virtual {
        create3Factory = Create3Deployer.deploy_create3Factory("SMS.CREATE3Factory");
        create3Factory2 = Create3Deployer.deploy_create3Factory("SMS.CREATE3Factory2");

        smsDataHub = create3Factory.deploy_SMSDataHubMainChain(address(this));
        sms = SMS(create3Factory.deploy_SMS(smsDataHub));
        mms = MMS(
            create3Factory.deploy_MMS(
                smsDataHub, twabPeriodLength, uint32(block.timestamp), ROUND_BP, 100 days
            )
        );
        adapter = SMSOmnichainAdapter(
            create3Factory.deploy_SMSOmnichainAdapter(smsDataHub, address(endPointA), address(this))
        );

        smsDataHub.setSMS(address(sms));
        smsDataHub.setMMS(address(mms));
        smsDataHub.grantRole(smsDataHub.SMS_MINTER_ROLE(), address(this));
        smsDataHub.grantRole(smsDataHub.SMS_CROSSCHAIN_MINTER_ROLE(), address(adapter));

        smsDataHub2 = SMSDataHub(create3Factory2.deploy_SMSDataHub(address(this)));
        sms2 = SMS(create3Factory2.deploy_SMS(smsDataHub2));
        adapter2 = SMSOmnichainAdapter(
            create3Factory2.deploy_SMSOmnichainAdapter(
                smsDataHub2, address(endPointB), address(this)
            )
        );

        smsDataHub2.setSMS(address(sms2));
        smsDataHub2.grantRole(smsDataHub2.SMS_MINTER_ROLE(), address(this));
        smsDataHub2.grantRole(smsDataHub2.SMS_CROSSCHAIN_MINTER_ROLE(), address(adapter2));

        address[] memory adapters = new address[](2);
        adapters[0] = address(adapter);
        adapters[1] = address(adapter2);

        wireOApps(adapters);

        vm.deal(address(this), 1 ether);
        vm.deal(address(adapter), 1 ether);
        vm.deal(address(adapter2), 1 ether);

        sms.mint(address(this), MINT_AMOUNT, mockData);
        sms2.mint(address(this), MINT_AMOUNT, mockData);

        sms.approve(address(adapter), type(uint256).max);
        sms2.approve(address(adapter2), type(uint256).max);
        sms.approve(address(mms), type(uint256).max);

        // All tests math rely on ROUND_BP = x2 per round
        if (ROUND_BP != mms.BP_PRECISION()) {
            assertEq(ROUND_BP, mms.BP_PRECISION(), "ROUND_BP is not equal to MMS.BP_PRECISION");
        }
    }

    function _setLabels() internal {
        vm.label(address(sms), "SMS");
        vm.label(address(mms), "MMS");
        vm.label(address(smsDataHub), "SMSDataHub");
        vm.label(address(adapter), "SMSOmnichainAdapter");
        vm.label(address(endPointA), "EndPointA");
        vm.label(address(endPointB), "EndPointB");
        vm.label(address(this), "THIS");
        vm.label(address(user), "USER");

        vm.label(address(sms2), "SMS2");
        vm.label(address(smsDataHub2), "SMSDataHub2");
        vm.label(address(adapter2), "SMSOmnichainAdapter2");
    }

    function _beforeSetUp() internal virtual {}

    function _afterSetUp() internal virtual {}
}
