#!/bin/bash
mkdir -p /workspace/GPT-SoVITS/GPT_SoVITS/pretrained_models/fast_langdetect

# Create torchaudio patch
cat > /workspace/GPT-SoVITS/patch_torchaudio.py << 'PYEOF'
import torchaudio, torch, soundfile as sf
def _p(uri, frame_offset=0, num_frames=-1, normalize=True, channels_first=True, format=None, buffer_size=4096, backend=None):
    data, sr = sf.read(str(uri), dtype="float32", start=frame_offset, stop=frame_offset+num_frames if num_frames > 0 else None)
    t = torch.from_numpy(data).float()
    return (t.unsqueeze(0) if t.dim()==1 else t.T), sr
torchaudio.load = _p
PYEOF

# Patch api_v2.py to import the torchaudio fix before anything else
if ! grep -q "patch_torchaudio" /workspace/GPT-SoVITS/api_v2.py; then
    sed -i '1i import patch_torchaudio' /workspace/GPT-SoVITS/api_v2.py
fi

exec python api_v2.py -a 0.0.0.0 -p 9880 -c GPT_SoVITS/configs/tts_infer.yaml
