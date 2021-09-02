import React, { useEffect, useState } from 'react';
import { Wheel, ShadeSlider, color } from '@uiw/react-color'

import socket from './socket';

export default function LightControl() {
  const [channel, setChannel] = useState(null);
  const [hsv, setHsv] = useState({ h: 0, s: 0, v: 1 });

  useEffect(() => {
    const channel = socket.channel('light');

    channel.join()
      .receive('ok', resp => {
        console.log('Joined successfully', resp);
        setChannel(channel);
        setHsv(resp.color);
      })
      .receive('error', resp => { console.log('Unable to join', resp) })

    channel.on('set_color', payload => {
      setHsv(payload.color);
    });

    return () => {
      channel.off('set_color');
      channel.leave();
    };
  }, [socket]);

  return (
    <>
      <Wheel
        color={hsv}
        onChange={(color) => {
          channel.push('set_color', { color: color.hsv });
        }}
      />
      <ShadeSlider
        hsva={hsv}
        onChange={(newShade) => {
          const newHsv = { ...hsv, ...newShade };
          channel.push('set_color', { color: newHsv });
        }}
      />
    </>
  );
}
