// Copyright (c) 2009-2019 The Bitcoin Core developers
// Copyright (c) 2018-2019 The KryptoFranc Core developers

// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef KRYPTOFRANC_CHECKPOINTS_H
#define KRYPTOFRANC_CHECKPOINTS_H

#include <uint256.h>

#include <map>

class CBlockIndex;
struct CCheckpointData;

/**
 * Block-chain checkpoints are compiled-in sanity checks.
 * They are updated every release or three.
 */
namespace Checkpoints
{

//! Returns last CBlockIndex* that is a checkpoint
CBlockIndex* GetLastCheckpoint(const CCheckpointData& data);

} //namespace Checkpoints

#endif // KRYPTOFRANC_CHECKPOINTS_H
