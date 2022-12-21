{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveAnyClass             #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE LambdaCase                 #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE NoImplicitPrelude          #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeApplications           #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE TypeOperators              #-}

{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Simple Application Carbon Credit Scientific Based Targets Rewards Smart Contract

module CarbonCreditRewardsFilter where

-- Import Dependency Data Environment 
import           Control.Monad        (void)
import           Data.Aeson           (ToJSON, FromJSON)
import           Data.List.NonEmpty   (NonEmpty (..))
import           Data.Map (Map)
import           Data.Map                  as Map
import           Data.Maybe (catMaybes)
import qualified Data.ByteString.Char8     as C
import           Data.Text            (pack, Text)
import           GHC.Generics         (Generic)

-- Import Dependency Plutus Environment 
import qualified PlutusTx                  as PlutusTx
import           PlutusTx.Prelude 
import           Plutus.Contract
import PlutusTx.Prelude hiding (pure, (<$>))
import Prelude qualified as Haskell

-- Import Dependency Ledger Environment 
import           Ledger                    (Address, Validator, ScriptContext, Value, scriptAddress, getCardanoTxId, ChainIndexTxOut(..), Datum (Datum), dataHash, Datum (..), DatumHash (..), PaymentPubKeyHash, TxInfo, scriptContextTxInfo, txSignedBy,unPaymentPubKeyHash)
import           Ledger                    hiding (singleton)
import           Ledger.Tx (ChainIndexTxOut (..))
import qualified Ledger.Constraints        as Constraints
import qualified Ledger.Typed.Scripts      as Scripts
import           Ledger.Value              as Value
import           Ledger.Ada                as Ada

-- Import Dependency Playground Environment 
import           Playground.Contract
import qualified Prelude
import qualified Prelude              as P
import Prelude (String)
import           Text.Printf          (printf)

-- Functor Definition
newtype HashedString = HashedString BuiltinByteString deriving newtype (PlutusTx.ToData, PlutusTx.FromData, PlutusTx.UnsafeFromData)
PlutusTx.makeLift ''HashedString


-----------------------------------------------------------------
-- | Carbon Credit Science Based Target Validation On-Chain Code
-----------------------------------------------------------------
minLovelace :: Integer
minLovelace = 2000000

-- | Carbon Credit Science Based Target Datum On-Chain Code
data SBTDatum = SBTDatum
    { beneficiary       :: !PaymentPubKeyHash           -- Public Hash Key Beneficiary Address 
    , set_BaselineYear  :: !Integer                     -- Baseline Year Science Based Target
    , set_TargetYear    :: !Integer                     -- Target Year Science Based Target
    , set_SBTTonCO2E    :: !Integer                     -- Science Based Target CO2 Emission in Tonnage
    , set_ERF           :: !Integer                     -- Target Year Emission Reduction Factor
    , set_rewardAmount  :: !Integer                     -- Carbon Emission Reward Amount
    , set_pin           :: !Integer                     -- Pin Reward Withdrawl Authorization 
    } deriving Show

         
PlutusTx.unstableMakeIsData ''SBTDatum
PlutusTx.makeLift ''SBTDatum

-- | Carbon Credit Rewards Redeemer On-Chain Code
data CCRewardRedeemer = CCRewardRedeemer
    { val_cc         :: !Integer			-- Validated Value of Current Year Carbon Emission in Tonnage
    , val_erf        :: !Integer			-- Validated Value 0f Current Year Emission Reduction Factor
    , val_pin        :: !Integer			-- Validated Pin Reward Withdrawl Authorization
    } deriving Show


PlutusTx.unstableMakeIsData ''CCRewardRedeemer
PlutusTx.makeLift ''CCRewardRedeemer


-- | Carbon Credit Emission Validation On-Chain Code
-- Transaction Validation to released Carbon Rewards through beneficiarry address matching, pin rewards authorization matching, and 
-- Carbon Emission shall be below Tonnage of Target Year Carbon Emission     
{-# INLINABLE validateCCEmission #-}
validateCCEmission :: SBTDatum -> CCRewardRedeemer -> ScriptContext -> Bool
validateCCEmission (SBTDatum phk _ _ ssbt serf _ dpnt) (CCRewardRedeemer valcc valerf vpnt) ctx = 
                                                                         traceIfFalse "Emission Target Not Achieved - Deposits Fund On Hold" $  ssbt * serf >= valcc*valerf  &&
                                                                        (traceIfFalse "Wrong Withdrawl Pin!" $ dpnt == vpnt) &&
                                                                         traceIfFalse "Beneficiary's Signature Not Matched" signedByBeneficiary
  where
    info :: TxInfo
    info = scriptContextTxInfo ctx

    signedByBeneficiary :: Bool
    signedByBeneficiary = txSignedBy info $ unPaymentPubKeyHash $ phk


-- | Datum and Redeemer parameter types
data CCRewards
instance Scripts.ValidatorTypes CCRewards where
    type instance DatumType CCRewards = SBTDatum
    type instance RedeemerType CCRewards = CCRewardRedeemer

-- | The script instance is the compiled validator (ready to go onto the chain)
ccRewardsInstance :: Scripts.TypedValidator CCRewards
ccRewardsInstance = Scripts.mkTypedValidator @CCRewards
  $$(PlutusTx.compile [|| validateCCEmission ||])
  $$(PlutusTx.compile [|| wrap ||])
    where
      wrap = Scripts.wrapValidator @SBTDatum @CCRewardRedeemer


-----------------------------------------------------------------
-- | Carbon Credit Science Based Target Validation Off-Chain Code
-----------------------------------------------------------------

-- | The Address of the Carbon Credit Science Based Target Rewards 
ccRewardsAddress :: Address
ccRewardsAddress = Ledger.scriptAddress (Scripts.validatorScript ccRewardsInstance)

-- | Parameters for the "Carbon Credit Science Based Target Rewards" endpoint
data SBTParams = SBTParams
    { rewardBeneficiary  :: !PaymentPubKeyHash          -- Public Hash Key Beneficiary Address  
    , baselineYear       :: !Integer                    -- Baseline Year Science Based Target
    , targetYear         :: !Integer                    -- Target Year Science Based Target                  
    , target_SBTTonCO2E  :: !Integer                    -- Science Based Target CO2 Emission in Tonnage
    , target_ERF         :: !Integer                    -- Target Year Emission Reduction Factor
    , amount_Rewards     :: !Integer                    -- Carbon Emission Reward Amount                 
    , pin                :: !Integer                    -- Pin Reward Withdrawl Authorization
    }
    deriving (Generic, ToJSON, FromJSON, ToSchema)

--  | Parameters for the "Carbon Emission Validation" endpoint
data CCEmissionParams = CCEmissionParams
    { val_Current_Emission_TonCO2E           :: !Integer    -- Validated Value of Current Year Carbon Emission in Tonnage
    , val_Current_Emission_Reduction_Factor  :: !Integer    -- Validated Value 0f Current Year Emission Reduction Factor
    , pin_validation                         :: !Integer    -- Validated Pin Reward Withdrawl Authorization
    }
    deriving stock (Prelude.Eq, Prelude.Show, Generic)
    deriving anyclass (FromJSON, ToJSON, ToSchema, ToArgument)

-- | The schema of the contract, with one endpoint to publish the problem with a Carbon Credit Science Based Target Rewards 
--   and to submit Carbon Emission Validation Value
type CCRewardsSchema =
            Endpoint "Science Base Target GHG Data Center and Funds Deposit" SBTParams    
        .\/ Endpoint "Updated Current GHG Data Center and Released Funds Deposit" CCEmissionParams

-- | The "Carbon Credit Science Based Target Rewards" contract endpoint.
ccsbtrewards :: AsContractError e => SBTParams -> Contract () CCRewardsSchema e ()
ccsbtrewards (SBTParams bnf baseyear targetyear sbttarget erftarget rewardAmt pnt ) = do
    let datDatum = SBTDatum
                { beneficiary       = bnf               -- SBT Datum Public Hash Key Beneficiary Address 
                , set_BaselineYear  = baseyear          -- SBT Datum Baseline Year Science Based Target
                , set_TargetYear    = targetyear        -- SBT Datum Target Year Science Based Target
                , set_SBTTonCO2E    = sbttarget         -- SBT Datum Science Based Target CO2 Emission in Tonnage       
                , set_ERF           = erftarget         -- SBT Datum Target Year Emission Reduction Factor
                , set_rewardAmount  = rewardAmt         -- SBT Datum Carbon Emission Reward Amount in ADA
                , set_pin           = pnt               -- SBT Datum Pin Reward Withdrawl Authorization
                }

    let tx   = Constraints.mustPayToTheScript datDatum $ Ada.lovelaceValueOf rewardAmt
    ledgerTx <- submitTxConstraints ccRewardsInstance tx
    void $ awaitTxConfirmed $ getCardanoTxId ledgerTx
    logInfo @String $ printf "Science Based Target Carbon Credit Emission Rewards with Baseline Year %d and Target Year %d"  baseyear targetyear
    logInfo @String $ printf "Science Based Target Carbon Credit Emission is %d TonCO2e"  (sbttarget * erftarget)
    logInfo @String $ printf "Carbon Credit Bonus Available Funds of %d and Token Rewards to be credited to Company with below Carbon Emission SBT Achievement on Target Year" rewardAmt

-- | The "Carbon Emission Validation" contract endpoint.
carbonemissionupdate :: AsContractError e => CCEmissionParams -> Contract () CCRewardsSchema e ()
carbonemissionupdate (CCEmissionParams valccemission targeterfvalue pin_validation) = do
    onow   <- currentTime
    opkh   <- ownPaymentPubKeyHash
    -- filter all incorrect datum ccsbtrewards scripts
    unspentOutputs <- Map.filter hasCorrectDatum <$> utxosAt ccRewardsAddress
    let datRedeemer = CCRewardRedeemer
                { val_cc   = valccemission              -- Carbon Emission Redeemer Validated Value of Current Year Carbon Emission in Tonnage
                , val_erf  = targeterfvalue             -- Carbon Emission Redeemer Validated Value 0f Current Year Emission Reduction Factor
                , val_pin  = pin_validation             -- Carbon Emission Redeemer Validated Pin Reward Withdrawl Authorization
                }

    let tx = collectFromScript unspentOutputs datRedeemer
    ledgerTx <- submitTxConstraintsSpending ccRewardsInstance unspentOutputs tx
    void $ awaitTxConfirmed $ getCardanoTxId ledgerTx
    logInfo @String $ printf "Congratulation !! This Year Carbon Emission Achievement is %d TonCO2e " (valccemission*targeterfvalue)  
    logInfo @String $ printf "Carbon Credit Rewards will be creditted to Account Beneficiary if Validated Carbon Emission Target Year below Science Based Target Value "
      where
        hasCorrectDatum :: ChainIndexTxOut -> Bool
        hasCorrectDatum (ScriptChainIndexTxOut _ _ (Right (Datum datum)) _)    =
          case PlutusTx.fromBuiltinData datum of
          Just d  -> valccemission * targeterfvalue <= (set_SBTTonCO2E d) * (set_ERF d) && pin_validation == (set_pin d)
          Nothing -> False
        hasCorrectDatum _ = False

-- | Carbon Credit Science Base Target Rewards endpoints.
endpoints :: AsContractError e => Contract () CCRewardsSchema e ()
endpoints = awaitPromise (ccsbtrewards' `select` carbonemissionupdate') >> endpoints
  where
    ccsbtrewards' = endpoint @"Science Base Target GHG Data Center and Funds Deposit" ccsbtrewards
    carbonemissionupdate' = endpoint @"Updated Current GHG Data Center and Released Funds Deposit" carbonemissionupdate

mkSchemaDefinitions ''CCRewardsSchema

