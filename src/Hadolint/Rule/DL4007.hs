module Hadolint.Rule.DL4007 (rule) where

import qualified Data.Text as Text
import Hadolint.Rule
import Hadolint.Shell (ParsedShell)
import qualified Hadolint.Shell as Shell
import Language.Docker.Syntax (Instruction(..), RunArgs(..))

rule :: Rule ParsedShell
rule = dl4007 <> onbuild dl4007
{-# INLINEABLE rule #-}

dl4007 :: Rule ParsedShell
dl4007 = simpleRule code severity message check
  where
    code = "DL4007"
    severity = DLWarningC
    message =
      "Install only essential dependencies. Instead of `npm ci/install`, `yarn install`, or `pnpm install/ci`, use the production flag (e.g., `--only=production`, `--production`, or `--prod`)."
    check (Run (RunArgs args _)) = foldArguments forgotToUseProduction args
    check _ = True

    forgotToUseProduction cmd =
      Shell.isNpmInstallOrCiWithoutProduction cmd ||
      Shell.isYarnInstallWithoutProduction cmd ||
      Shell.isPnpmInstallOrCiWithoutProduction cmd

{-# INLINEABLE dl4007 #-}